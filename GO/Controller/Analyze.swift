//
//  Analyze.swift
//  GO
//
//  Created by Eddie Huang on 3/21/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import Foundation

class Analyze {
    
    static func containsFilledBlock(ofSize n: Int, forPlayer player: Player, onGrid grid: [[Player?]]) -> Bool {
        let allBlocks = getAllBlocks(forPlayer: player, onGrid: grid)
        let ret = allBlocks.filter { (block) -> Bool in
            if block.length == n {
                var curr = block.point
                for _ in 1...n {
                    if grid[curr.x][curr.y] != player {
                        return false
                    }
                    curr = curr.point(inDirection: block.direction)
                }
                return true
            }
            return false
        }
        
        return ret.count > 0
    }
    
    static func getAllBlocks(forPlayer player: Player, onGrid grid: [[Player?]]) -> Set<Block> {
        let dimension = grid.count
        
        var ret = Set<Block>()
        
        let directions: [Direction] = [.east, .north, .northEast, .southEast]
        for i in 0..<dimension {
            for j in 0..<dimension {
                for distance in 1..<dimension {
                    for direction in directions {
                        let p = Point(i, j)
                        let otherP = p.point(inDirection: direction, atDistance: distance)
                        if !inBounds(grid: grid, point: otherP) {
                            continue
                        }
                        
                        // Make sure none of the points inside are the opponents
                        var valid = true
                        var curr = p
                        for _ in 0...distance {
                            if grid[curr.x][curr.y] == player.opponent {
                                valid = false
                                break
                            }
                            curr = curr.point(inDirection: direction)
                        }
                        if !valid {
                            continue
                        }
                        
                        let block = Block(point: p, direction: direction, length: distance + 1)
                        ret.insert(block)
                    }
                }
            }
        }
        return ret
    }
    
    static func inBounds(grid: [[Player?]], point: Point) -> Bool {
        let dimension = grid.count
        if point.x < 0 || point.y < 0 {
            return false
        }
        if point.x >= dimension || point.y >= dimension {
            return false
        }
        
        return true
    }
    
    static func numberOfLiberties(grid: [[Player?]], group: Set<Point>) -> Int {
        var empties = Set<Point>()
        let dimension = grid.count
        
        for piece in group {
            let up = Point(piece.x, piece.y+1)
            let right = Point(piece.x+1, piece.y)
            let down = Point(piece.x, piece.y-1)
            let left = Point(piece.x-1, piece.y)
            
            if right.x < Int(dimension) && grid[Int(right.x)][Int(right.y)] == nil {
                empties.insert(right)
            }
            
            if left.x >= 0 && grid[left.x][left.y] == nil {
                empties.insert(left)
            }
            
            if up.y < Int(dimension) && grid[up.x][up.y] == nil {
                empties.insert(up)
            }
            
            if down.y >= 0 && grid[down.x][down.y] == nil {
                empties.insert(down)
            }
        }
        
        return Int(empties.count)
    }
    
    static func adjacent(grid: [[Player?]], point: Point, player: Player) -> Set<Point> {
        var s = Set<Point>()
        let dimension = grid.count
        
        let up = Point(point.x, point.y+1)
        let right = Point(point.x+1, point.y)
        let down = Point(point.x, point.y-1)
        let left = Point(point.x-1, point.y)
        
        if right.x < dimension && grid[right.x][right.y] == player {
            s.insert(right)
        }
        
        if left.x >= 0 && grid[left.x][left.y] == player {
            s.insert(left)
        }
        
        if up.y < Int(dimension) && grid[up.x][up.y] == player {
            s.insert(up)
        }
        
        if down.y >= 0 && grid[down.x][down.y] == player {
            s.insert(down)
        }
        
        return s
    }
    
    
    static func explore(grid: [[Player?]], point: Point, player: Player) -> Set<Point> {
        var s = Set<Point>()
        var q = Queue<Point>()
        let dimension = grid.count
        
        if point.x < 0 || point.x >= Int(dimension) || point.y < 0 || point.y >= Int(dimension) {
            return s
        }
        
        if grid[Int(point.x)][Int(point.y)] == nil || grid[Int(point.x)][Int(point.y)] == player.opponent {
            return s
        }
        
        s.insert(point)
        q.enqueue(point)
        
        while let current = q.dequeue() {
            let adjacent = Analyze.adjacent(grid: grid, point: current, player: player)
            
            for a in adjacent {
                if !s.contains(a) {
                    s.insert(a)
                    q.enqueue(a)
                }
            }
        }
        
        return s
    }
    
    static func numberOfLiberties(_ grid: [[Player?]], point: Point) -> Int {
        let up = Point(point.x, point.y+1)
        let right = Point(point.x+1, point.y)
        let down = Point(point.x, point.y-1)
        let left = Point(point.x-1, point.y)
        
        let dimension = grid.count
        
        var count: Int = 0
        
        if right.x < Int(dimension) && grid[Int(right.x)][Int(right.y)] == nil {
            count += 1
        }
        
        if left.x >= 0 && grid[left.x][left.y] == nil {
            count += 1
        }
        
        if up.y < Int(dimension) && grid[up.x][up.y] == nil {
            count += 1
        }
        
        if down.y >= 0 && grid[down.x][down.y] == nil {
            count += 1
        }
        
        return count
    }
    
    ///Returns an array of all the representatives of groups that are adjacent to the coordinate and are of the same color. Does not exclude its own representative if it exists
    static func getAdjacentGroups(_ grid: [[Player?]], coor: Point, player: Player) -> Set<Set<Point>> {
        var ret = Set<Set<Point>>()
        
        let up = Point(coor.x, coor.y+1)
        let right = Point(coor.x+1, coor.y)
        let down = Point(coor.x, coor.y-1)
        let left = Point(coor.x-1, coor.y)
        
        let centerGroup = Analyze.explore(grid: grid, point: coor, player: player)
        let upGroup = Analyze.explore(grid: grid, point: up, player: player)
        let rightGroup = Analyze.explore(grid: grid, point: right, player: player)
        let downGroup = Analyze.explore(grid: grid, point: down, player: player)
        let leftGroup = Analyze.explore(grid: grid, point: left, player: player)
        
        let list = [centerGroup,upGroup,rightGroup,downGroup,leftGroup]
        
        for group in list {
            if !group.isEmpty {
                ret.insert(group)
            }
        }
        return ret
    }
    
    static func getAdjacentTeamGroups(_ grid: [[Player?]], point: Point, player: Player) -> Set<Set<Point>> {
        return getAdjacentGroups(grid, coor: point, player: player)
    }
    
    static func getAdjacentOpposingGroups(_ grid: [[Player?]], point: Point, player: Player) -> Set<Set<Point>> {
        return getAdjacentGroups(grid, coor: point, player: player.opponent)
    }
    
    static func exploreEmpty(grid: [[Player?]], point: Point) -> Set<Point> {
        var s = Set<Point>()
        var q = Queue<Point>()
        
        let dimension = grid.count
        
        if point.x < 0 || point.x >= Int(dimension) || point.y < 0 || point.y >= Int(dimension) {
            return s
        }
        
        if grid[Int(point.x)][Int(point.y)] != nil {
            return s
        }
        
        s.insert(point)
        q.enqueue(point)
        
        while let current = q.dequeue(){
            let adjacent = adjacentEmpty(grid: grid, coor: current)
            
            for a in adjacent {
                if !s.contains(a) {
                    s.insert(a)
                    q.enqueue(a)
                }
            }
        }
        
        return s
    }
    
    
    static func adjacentEmpty(grid: [[Player?]], coor: Point) -> Set<Point> {
        let dimension = grid.count
        
        var s = Set<Point>()
        
        let up = Point(coor.x, coor.y+1)
        let right = Point(coor.x+1, coor.y)
        let down = Point(coor.x, coor.y-1)
        let left = Point(coor.x-1, coor.y)
        
        if right.x < dimension && grid[right.x][right.y] == nil {
            s.insert(right)
        }
        
        if left.x >= 0 && grid[left.x][left.y] == nil {
            s.insert(left)
        }
        
        if up.y < Int(dimension) && grid[up.x][up.y] == nil {
            s.insert(up)
        }
        
        if down.y >= 0 && grid[down.x][down.y] == nil {
            s.insert(down)
        }
        
        return s
    }
    
    static func adjacentEmpty(grid: [[Player?]], group: Set<Point>) -> Set<Point> {
        var ret = Set<Point>()
        
        for coor in group {
            let adjacentEmpties = adjacentEmpty(grid: grid, coor: coor)
            ret.formUnion(adjacentEmpties)
        }
        
        return ret
    }
    
    // TODO: This is unused
    static func getAllGroups(grid: [[Player?]], sorted: Bool) -> Array<Set<Point>> {
        
        let dimension = grid.count
        var ret = Set<Set<Point>>()
        
        var visited = Set<Point>()
        for i in 0...dimension-1 {
            for j in 0...dimension-1 {
                if let color = grid[i][j] {
                    let coor = Point(i,j)
                    if !visited.contains(coor) {
                        let group = Analyze.explore(grid: grid, point: coor, player: color)
                        if !group.isEmpty {
                            ret.insert(group)
                            visited.formUnion(group)
                        }
                    }
                }
            }
        }
        
        if sorted {
            let sortedGroups = ret.sorted(by: {
                a,b in
                let aLiberty = Analyze.numberOfLiberties(grid: grid, group: a)
                let bLiberty = Analyze.numberOfLiberties(grid: grid, group: b)
                return aLiberty < bLiberty
            })
            
            return sortedGroups
        } else {
            return Array<Set<Point>>(ret)
        }
    }
}
