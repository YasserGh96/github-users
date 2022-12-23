//
//  Logs.swift
//  GitHub Users
//
//  Created by Yasser Ghannam on 29/11/2022.
//

import Foundation

// MARK: - Console Log
func log(_ args: Any...) {
    print_log(args, oneLine: true)
}

func logs(_ args: Any...) {
    print_log(args, oneLine: false)
}

fileprivate func print_log(_ args: Any..., oneLine: Bool) {

    if oneLine {
        print(args)
    } else {
        for line in args {
            print(line)
        }
    }
}
