//
//  ScheduleManager.swift
//  OnTaskCL
//
//  This class is the managing class for all OnTask functions and data structures.
//
//  Created by Steven James McDonald on 9/9/19.
//  This software is open source under the GNU 3 license.
//
/*
 
 TODO:
    a. Database for storing events created by this application.
    b. On boot the application should see if the user removed any of the events created by this application and decide how we want to handle this.
    c. Functions for creating and removing events created by this application only!
 
 
 
*/

import Foundation
import EventKit

//
struct Preferences : Codable {
    
    var FirstBoot : Bool;
    var UseUserCalendar : Bool;
    
}

class ScheduleManager {
    
    init() {
        
        //Set user calendar type:
        self.userCalendar = Calendar.current;
        let eventStore = EKEventStore();
        store = eventStore;
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            print("DEBUG: Calendar access authorized!");
//            userPrefs!.UseUserCalendar = true;
//            writePrefs(preferences: userPrefs!);
//            userPrefs = readPrefs();
            
        case .denied:
            print("DEBUG: Calendar access denied.");
//            userPrefs!.UseUserCalendar = false;
//            writePrefs(preferences: userPrefs!);
//            userPrefs = readPrefs();
            
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        print("DEBUG: Access granted!");
                    } else {
                        print("DEBUG: Access denied.");
                    }
            })
        default:
            print("DEBUG: Case default");
        }
        
        userPrefs = readPrefs();
        
        print("DEBUG: Calendar type:", userCalendar.identifier);
        //print(store?.defaultCalendarForNewEvents?.title);
        print("DEBUG: FirstBoot:", userPrefs!.FirstBoot);
        print("DEBUG: UseUserCalendar:", userPrefs!.UseUserCalendar);
        print("DEBUG: ScheduleManager intitialized successfully!\n");
        
    }
    
    //This function will read in Preferences.plist and return it as a Preferences struct.
    func readPrefs() -> Preferences? {
        
        if  let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml)
        {
            print("DEBUG: Prefs plist loaded successfully.");
            return preferences;
            //prefs = preferences;
            
        } else {
            
            //TODO: Generate a fresh preferences file here and return that.
            print("DEBUG: Preferences file not found!");
            return nil;
            
        }
        
    }
    
    func getStore() -> EKEventStore {
        return store!;
    }
    
    //Fields:
    private var store : EKEventStore?;
    private var userCalendar : Calendar;
    private var userPrefs : Preferences?;

}
