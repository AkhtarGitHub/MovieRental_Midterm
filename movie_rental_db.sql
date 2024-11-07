-- Movies Table
CREATE TABLE IF NOT EXISTS Movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT NOT NULL,
    genre VARCHAR(50) NOT NULL,
    director VARCHAR(255) NOT NULL
);

-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone TEXT NOT NULL
);

-- Rentals Table
CREATE TABLE IF NOT EXISTS Rentals (
    rental_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    movie_id INT REFERENCES Movies(movie_id) ON DELETE CASCADE,
    rental_date DATE NOT NULL,
    return_date DATE
);


-- Insert Sample Movies
INSERT INTO Movies (title, release_year, genre, director)
VALUES
    ('Inception', 2010, 'Science Fiction', 'Christopher Nolan'),
    ('The Matrix', 1999, 'Action', 'Lana Wachowski, Lilly Wachowski'),
    ('Parasite', 2019, 'Thriller', 'Bong Joon-ho'),
    ('The Godfather', 1972, 'Crime', 'Francis Ford Coppola'),
    ('The Dark Knight', 2008, 'Action', 'Christopher Nolan');

-- Insert Sample Customers
INSERT INTO Customers (first_name, last_name, email, phone)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '1234567890'),
    ('Jane', 'Smith', 'jane.smith@example.com', '0987654321'),
    ('Alice', 'Johnson', 'alice.johnson@example.com', '5551234567'),
    ('Bob', 'Brown', 'bob.brown@example.com', '5559876543'),
    ('Charlie', 'Davis', 'charlie.davis@example.com', '5555555555');

-- Insert Sample Rentals
INSERT INTO Rentals (customer_id, movie_id, rental_date, return_date)
VALUES
    (1, 1, '2024-10-01', '2024-10-08'),
    (1, 2, '2024-10-10', '2024-10-17'),
    (2, 1, '2024-09-15', '2024-09-22'),
    (2, 3, '2024-10-05', '2024-10-12'),
    (3, 4, '2024-10-02', NULL),
    (3, 5, '2024-09-20', '2024-09-27'),
    (4, 2, '2024-10-01', NULL),
    (4, 3, '2024-09-25', '2024-10-02'),
    (5, 4, '2024-10-03', '2024-10-10'),
    (5, 5, '2024-10-06', '2024-10-13');


-- Find all movies rented by a specific customer, given their email.
SELECT Movies.title
FROM Rentals
JOIN Customers ON Rentals.customer_id = Customers.customer_id
JOIN Movies ON Rentals.movie_id = Movies.movie_id
WHERE Customers.email = 'john.doe@example.com';


-- Given a movie title, list all customers who have rented the movie
SELECT Customers.first_name, Customers.last_name
FROM Rentals
JOIN Movies ON Rentals.movie_id = Movies.movie_id
JOIN Customers ON Rentals.customer_id = Customers.customer_id
WHERE Movies.title = 'Inception';

	
-- Get the rental history for a specific movie title
SELECT Rentals.rental_date, Rentals.return_date, Customers.first_name, Customers.last_name
FROM Rentals
JOIN Movies ON Rentals.movie_id = Movies.movie_id
JOIN Customers ON Rentals.customer_id = Customers.customer_id
WHERE Movies.title = 'The Matrix';


-- For a specific movie director: Find the name of the customer, the date of the rental and title of the movie, each time a movie by that director was rented
SELECT Customers.first_name, Customers.last_name, Rentals.rental_date, Movies.title
FROM Rentals
JOIN Movies ON Rentals.movie_id = Movies.movie_id
JOIN Customers ON Rentals.customer_id = Customers.customer_id
WHERE Movies.director = 'Christopher Nolan';


-- List all currently rented out movies (movies who's return dates haven't been met)
SELECT Movies.title, Customers.first_name, Customers.last_name, Rentals.rental_date
FROM Rentals
JOIN Movies ON Rentals.movie_id = Movies.movie_id
JOIN Customers ON Rentals.customer_id = Customers.customer_id
WHERE Rentals.return_date IS NULL;

