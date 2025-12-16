-- 1. What is the distribution of booking cancellations in the hotel?
SELECT 
    is_canceled,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM hotel_booking
GROUP BY is_canceled
ORDER BY is_canceled;

-- 2. What is the relationship between lead time and the likelihood of cancellation?
SELECT 
    CASE 
        WHEN lead_time <= 7 THEN '0-7 days'
        WHEN lead_time <= 30 THEN '8-30 days'
        WHEN lead_time <= 90 THEN '31-90 days'
        WHEN lead_time <= 180 THEN '91-180 days'
        ELSE '180+ days'
    END as lead_time_category,
    COUNT(*) as total_bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) as canceled_bookings,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as cancellation_rate
FROM hotel_booking
GROUP BY lead_time_category
ORDER BY MIN(lead_time);

-- 3. Which months have the highest frequency of booking cancellations?
SELECT 
    arrival_date_month,
    COUNT(*) as total_bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) as canceled_bookings,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as cancellation_rate
FROM hotel_booking
GROUP BY arrival_date_month
ORDER BY canceled_bookings DESC;

-- 4. Which countries are most common among guests?
SELECT 
    country,
    COUNT(*) as guest_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM hotel_booking
WHERE country IS NOT NULL AND country != ''
GROUP BY country
ORDER BY guest_count DESC
LIMIT 10;

-- 5. How does the average daily rate (ADR) differ between different room types?
SELECT 
    reserved_room_type,
    COUNT(*) as booking_count,
    ROUND(AVG(adr), 2) as average_adr,
    ROUND(MIN(adr), 2) as min_adr,
    ROUND(MAX(adr), 2) as max_adr
FROM hotel_booking
WHERE adr > 0
GROUP BY reserved_room_type
ORDER BY average_adr DESC;

-- 6. What is the impact of having children or infants on the length of stay?
SELECT 
    CASE 
        WHEN children > 0 OR babies > 0 THEN 'With Children/Babies'
        ELSE 'Without Children/Babies'
    END as has_children,
    COUNT(*) as booking_count,
    ROUND(AVG(stays_in_weekend_nights + stays_in_week_nights), 2) as avg_total_nights,
    ROUND(AVG(stays_in_weekend_nights), 2) as avg_weekend_nights,
    ROUND(AVG(stays_in_week_nights), 2) as avg_week_nights
FROM hotel_booking
GROUP BY has_children
ORDER BY avg_total_nights;

-- 7. Which distribution channels are most effective in terms of low cancellation rates?
SELECT 
    distribution_channel,
    COUNT(*) as total_bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) as canceled_bookings,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as cancellation_rate
FROM hotel_booking
GROUP BY distribution_channel
ORDER BY cancellation_rate;

-- 8. What is the average number of nights guests stay on weekends compared to weekdays?
SELECT 
    'Weekend Nights' as night_type,
    ROUND(AVG(stays_in_weekend_nights), 2) as avg_nights,
    ROUND(MIN(stays_in_weekend_nights), 2) as min_nights,
    ROUND(MAX(stays_in_weekend_nights), 2) as max_nights
FROM hotel_booking

UNION ALL

SELECT 
    'Weekday Nights' as night_type,
    ROUND(AVG(stays_in_week_nights), 2) as avg_nights,
    ROUND(MIN(stays_in_week_nights), 2) as min_nights,
    ROUND(MAX(stays_in_week_nights), 2) as max_nights
FROM hotel_booking;

-- 9. How does booking behavior differ between new guests and repeated guests?
SELECT 
    CASE WHEN is_repeated_guest = 1 THEN 'Repeated Guest' ELSE 'New Guest' END as guest_type,
    COUNT(*) as booking_count,
    ROUND(AVG(lead_time), 2) as avg_lead_time,
    ROUND(AVG(adr), 2) as avg_adr,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as cancellation_rate,
    ROUND(AVG(stays_in_weekend_nights + stays_in_week_nights), 2) as avg_total_nights
FROM hotel_booking
GROUP BY guest_type
ORDER BY booking_count DESC;

-- 10. What factors are associated with requirements for car parking spaces?
SELECT 
    required_car_parking_spaces,
    COUNT(*) as booking_count,
    ROUND(AVG(adults), 2) as avg_adults,
    ROUND(AVG(children), 2) as avg_children,
    ROUND(AVG(adr), 2) as avg_adr,
    ROUND(AVG(lead_time), 2) as avg_lead_time
FROM hotel_booking
GROUP BY required_car_parking_spaces
ORDER BY required_car_parking_spaces;

-- 11. What is the impact of meal type on the average daily rate?
SELECT 
    meal,
    COUNT(*) as booking_count,
    ROUND(AVG(adr), 2) as average_adr,
    ROUND(MIN(adr), 2) as min_adr,
    ROUND(MAX(adr), 2) as max_adr
FROM hotel_booking
WHERE adr > 0
GROUP BY meal
ORDER BY average_adr DESC;

-- 12. What is the relationship between customer type and average length of stay?
SELECT 
    customer_type,
    COUNT(*) as booking_count,
    ROUND(AVG(stays_in_weekend_nights + stays_in_week_nights), 2) as avg_total_nights,
    ROUND(AVG(stays_in_weekend_nights), 2) as avg_weekend_nights,
    ROUND(AVG(stays_in_week_nights), 2) as avg_week_nights,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as cancellation_rate
FROM hotel_booking
GROUP BY customer_type
ORDER BY avg_total_nights DESC;

-- 13. What are the seasonal patterns in bookings and cancellations?
SELECT 
    arrival_date_month,
    arrival_date_year,
    COUNT(*) as total_bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) as canceled_bookings,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as cancellation_rate,
    ROUND(AVG(adr), 2) as avg_adr
FROM hotel_booking
GROUP BY arrival_date_month, arrival_date_year
ORDER BY arrival_date_year, 
    CASE arrival_date_month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
        WHEN 'July' THEN 7
        WHEN 'August' THEN 8
        WHEN 'September' THEN 9
        WHEN 'October' THEN 10
        WHEN 'November' THEN 11
        WHEN 'December' THEN 12
    END;

-- 14. How does deposit type affect cancellation rates?
SELECT 
    deposit_type,
    COUNT(*) as total_bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) as canceled_bookings,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as cancellation_rate,
    ROUND(AVG(adr), 2) as avg_adr
FROM hotel_booking
GROUP BY deposit_type
ORDER BY cancellation_rate DESC;

-- 15. What are the most common special requests made by guests?
SELECT 
    total_of_special_requests,
    COUNT(*) as booking_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage,
    ROUND(AVG(adr), 2) as avg_adr,
    ROUND(SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as cancellation_rate
FROM hotel_booking
GROUP BY total_of_special_requests
ORDER BY total_of_special_requests;