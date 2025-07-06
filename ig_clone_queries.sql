use ig_clone;

-- Read Data --
select * from users;
select * from comments;
select * from follows;
select * from likes;
select * from photo_tags;
select * from photos;
select * from tags;

-- Find the 5 oldest users --
SELECT 
    username, created_at
FROM
    users
ORDER BY created_at
LIMIT 5;

-- Find the users who have never posted a single photo on Instagram --
SELECT 
    users.username
FROM
    users
        LEFT JOIN
    photos ON users.id = photos.id
WHERE
    photos.image_url IS NULL
ORDER BY users.username;

-- Identify who has the most number of likes count and provide theri details to the team --
SELECT 
    likes.photo_id,
    users.username,
    COUNT(likes.user_id) AS no_of_likes
FROM
    likes
        INNER JOIN
    photos ON likes.photo_id = photos.id
        INNER JOIN
    users ON photos.user_id = users.id
GROUP BY likes.photo_id , users.username
ORDER BY no_of_likes DESC;

-- Identify and suggest the top 5 most commonly used hashtags --
SELECT 
    t.tag_name, COUNT(p.photo_id) AS hashtags
FROM
    photo_tags AS p
        INNER JOIN
    tags AS t ON t.id = p.tag_id
GROUP BY t.tag_name
ORDER BY hashtags DESC
LIMIT 5;

-- What day of the week do most users register on? Provide insights on when to schedule as ad campaign --
SELECT 
    DATE_FORMAT((created_at), '%d') AS day, COUNT(username)
FROM
    users
GROUP BY 1 order by 2 desc; 

-- Provide how many times does average users post on Instagram. Also, provide the total number of photos on Instagram/total number of users --
select * from photos, users;
with base as( 
select u.id as userid, count(p.id) as photoid from users as u left join photos as p on p.user_id=u.id group by u.id) 
select sum(photoid) as tot_photos, count(userid) as tot_users, sum(photoid)/count(userid) as photo_per_user from base;

-- Provide data on users(bots) who have liked every single photo on the site (since any normal user would not be able to do this so fiind bots) --
select * from users, likes;
with base as(
select u.username, count(l.photo_id) as likess from likes as l inner join users as u on u.id=l.user_id group by u.username)
select username, likess from base where likess=(select count(*) from photos) order by username;
