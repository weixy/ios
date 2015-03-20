//
//  AlbumExtensions.swift
//  MyMusicLibrary
//
//  Created by weixy on 9/03/15.
//  Copyright (c) 2015 j1mw3i. All rights reserved.
//

import Foundation

extension Album {
    func ae_tableRepresentation() -> (titles:[String], values:[String]) {
        return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
}