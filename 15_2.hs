import Prelude
import Data.List


parseCoordinate :: String -> Int
parseCoordinate s = do
    let i = (elemIndices '=' s) !! 0
    let str = (drop (i + 1) s)
    read str :: Int

parseCoordinates :: String -> (Int, Int)
parseCoordinates s = do
    let i = (elemIndices ',' s) !! 0
    let part1 = (take i s)
    let part2 = (drop (i + 1) s)
    (parseCoordinate(part1), parseCoordinate(part2))

parse :: String -> ((Int, Int), (Int, Int))
parse s = do
    let i = (elemIndices ':' s) !! 0
    let part1 = (take i s)
    let part2 = (drop (i + 1) s)
    (parseCoordinates(part1), parseCoordinates(part2))

projection :: Int -> ((Int, Int), (Int, Int)) -> (Int, Int)
projection y sensor_pair = do
    let sensor = (fst sensor_pair)
    let (sensor, beacon) = sensor_pair
    let distance = abs((fst sensor) - (fst beacon)) + abs((snd sensor) - (snd beacon))
    let d = abs((snd sensor) - y)
    let y = if d > distance
        then (1, 0)
        else do
            let temp = distance - d
            ((fst sensor) - temp, (fst sensor) + temp)
    y


mergeIntervals :: [(Int, Int)] -> [(Int, Int)]
mergeIntervals intervals = do
    if length intervals == 1
        then intervals
    else do
        let a = head intervals
        let b = head (tail intervals)
        let r = tail (tail intervals)

        if (fst b) <= ((snd a) + 1)
            then
                mergeIntervals ([((fst a), (max (snd b) (snd a)))] ++ r)
            else
                [a] ++ (mergeIntervals ([b] ++ r))


help :: [((Int, Int), (Int, Int))] -> Int -> [(Int, Int)]
help sensors y = do
    let projections = map (projection y) sensors
    let l = sort (filter (\x -> (fst x) <= (snd x)) projections)
    let merged = mergeIntervals l
    filter (not . (\x -> (snd x) < 0 || (fst x > 20))) merged

solve :: [((Int, Int), (Int, Int))] -> Int -> Int
solve sensors y = do
    let projections = map (projection y) sensors
    let l = sort (filter (\x -> (fst x) <= (snd x)) projections)
    let merged = mergeIntervals l
    let s = filter (not . (\x -> (snd x) < 0 || (fst x > 4000000))) merged
    if (length s) == 1
        then 0
        else ((fst (s !! 1)) - 1) * 4000000 + y

main :: IO ()
main = do
    input <- getContents
    let linesOfInput = lines input
    let sensors = map parse linesOfInput
    let projections = map (projection 4000000) sensors
    let l = sort (filter (\x -> (fst x) <= (snd x)) projections)
    let merged = mergeIntervals l
    print(foldl (\acc x -> acc + (snd x) - (fst x)) 0 merged)
    print(foldl (\acc x -> acc + x) 0 (map (solve sensors) [0..4000000]))
