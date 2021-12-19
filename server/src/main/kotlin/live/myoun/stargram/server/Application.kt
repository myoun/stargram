package live.myoun.stargram.server

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import com.google.gson.Gson
import io.ktor.application.*
import io.ktor.features.*
import io.ktor.http.*
import io.ktor.request.*
import io.ktor.response.*
import io.ktor.routing.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import org.neo4j.driver.AuthTokens
import org.neo4j.driver.GraphDatabase
import java.nio.file.Path
import java.util.*


fun main() {
    embeddedServer(Netty, environment = applicationEngineEnvironment {
        module(Application::module)
        connector {
            port = 8080
            host = "127.0.0.1"
        }
    }).start(wait = true)
}

val gson = Gson()

data class AccountPair(val id: String, val password: String)

fun Application.module() {

    val db = let {
        val mapper = jacksonObjectMapper()
        val accountPair: AccountPair = mapper.readValue(Path.of("config.json").toFile())
        Neo4j("neo4j://localhost:7687", accountPair.id, accountPair.password)
    }

    install(CORS) {
        method(HttpMethod.Get)
        method(HttpMethod.Post)
        header(HttpHeaders.Authorization)
        anyHost() // @TODO: Don't do this in production if possible. Try to limit it.
    }

    routing {
        post("/user") {
            val body = call.receiveText()
            val tempuser = gson.fromJson(body, UserWithoutId::class.java)
            val user = User(tempuser.name, UUID.randomUUID(), tempuser.email)
            db.createUser(user)
            call.respondText {
                gson.toJson(user)
            }
        }
        get("/user") {
            val query = call.request.queryParameters
            if (!query["id"].isNullOrBlank()) {
                call.respondText(
                    db.getUserById(UUID.fromString(query["id"]))
                )
            } else if (!query["name"].isNullOrBlank() && !query["email"].isNullOrBlank()) {
                val data = db.getUserByEmailAndName(query["email"]!!, query["name"]!!)
                call.respondText(data)
            }
            call.respond(HttpStatusCode.BadRequest)
        }
    }
}

class Neo4j(uri: String, user: String, password: String) : AutoCloseable {

    private val driver = GraphDatabase.driver(uri, AuthTokens.basic(user, password))

    override fun close() = driver.close()

    fun createUser(user: User) {
        driver.session().use { session ->
            session.writeTransaction {
                it.run(
                    """create (user:User {name:"${user.name}", id:"${user.id}", email: "${user.email}"})"""
                )
            }
        }
    }

    fun createPost() {
        driver.session().use { session ->
            session.writeTransaction {
                it.run(
                    """create (post:Post {image:"${"대충 url"}", content: "${"대충 컨텐츠 내용"}", id: "${"대충 UUID"}", writer: "${"대충 오너 UUID"}"}) """
                )
            }
        }
    }

    fun getUserByName(name: String): String {
        return driver.session().use { session ->
            session.writeTransaction {
                val data = it.run("""match (user:User) where user.name="$name" return user""").next()
                gson.toJson(data.fields()[0].value().asMap())
            }
        }
    }

    fun getUserById(id: UUID): String = driver.session().use { session ->
        return session.writeTransaction {
            val data = it.run(
                """match (user:User) where user.id="$id" return user"""
            ).next()
            gson.toJson(data.fields()[0].value().asMap())
        }
    }

    fun getUserByEmail(email: String): String = driver.session().use { session ->
        return session.writeTransaction {
            val data = it.run(
                """match (user:User) where user.email="$email" return user"""
            ).next()
            gson.toJson(data.fields()[0].value().asMap())
        }
    }

    fun getUserByEmailAndName(email: String, name: String): String = driver.session().use { session ->
        return session.writeTransaction {
            val data = it.run(
                """match (user:User) where user.email="$email" and user.name="$name" return user"""
            ).next()
            gson.toJson(data.fields()[0].value().asMap())
        }
    }
}

data class User(val name: String, val id: UUID, val email: String)
data class UserWithoutId(val name: String, val email: String)