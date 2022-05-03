//
//  DateHandler.swift
//  FinalProject_WishList
//
//  Created by Zhiling huang on 5/1/22.
//

import Foundation

enum constellation: CustomStringConvertible{
    
    case Aquarius
    case Pisces
    case Aries
    case Taurus
    case Gemini
    case Cancer
    case Leo
    case Virgo
    case Libra
    case Scorpio
    case Sagittarius
    case Capricorn
    var description: String {
        switch self {
        case .Aquarius:
            return "Aquarius"
        case .Pisces:
            return "Pisces"
        case .Aries:
            return "Aries"
        case .Taurus:
            return "Taurus"
        case .Gemini:
            return "Gemini"
        case .Cancer:
            return "Cancer"
        case .Leo:
            return "Leo"
        case .Virgo:
            return "Virgo"
        case .Libra:
            return "Libra"
        case .Scorpio:
            return "Scorpio"
        case .Sagittarius:
            return "Sagittarius"
        case .Capricorn:
            return "Capricorn"
        }
    }
    
}

class DateHandler {
    
    func getDateByString(_ date: String) -> Date?{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-d"
        guard let monthDay: Date = dateformatter.date(from: date) else {
            return nil
        }
        return monthDay
    }
    
    func getStringByDate(_ date: Date, format: String)-> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        let stringdate = dateformatter.string(from: date)
        return stringdate
        
    }
    func FindYourConstellation(_ mydate: Date?)-> constellation?{
        guard let date = mydate else {
            return nil
        }

        guard let AquariusfromDate = getDateByString("01-21") else{
            return nil
        }
        guard let PiscesfromDate = getDateByString("02-20") else {
            return nil
        }
        guard let AriesfromDate = getDateByString("03-21") else {
            return nil
        }
        guard let TaurusfromDate = getDateByString("04-21") else {
            return nil
        }
        guard let GeminifromDate = getDateByString("05-22") else {
            return nil
        }
        guard let CancerfromDate = getDateByString("06-22") else {
            return nil
        }
        guard let LeofromDate = getDateByString("07-23") else {
            return nil
        }
        guard let VirgofromDate = getDateByString("08-23") else {
            return nil
        }
        guard let LibrafromDate = getDateByString("09-23") else {
            return nil
        }
        guard let ScorpiofromDate = getDateByString("10-24") else {
            return nil
        }
        guard let SagittariusfromDate = getDateByString("11-22") else {
            return nil
        }
        guard let CapricornfromDate = getDateByString("12-21") else {
            return nil
        }
        
        var sign = constellation.Capricorn
        
        if date >= AquariusfromDate && date < PiscesfromDate {
            sign = constellation.Aquarius
        }
        if date >= PiscesfromDate && date < AriesfromDate {
            sign = constellation.Pisces
        }
        if date >= AriesfromDate && date < TaurusfromDate {
            sign = constellation.Aries
        }
        if date >= TaurusfromDate && date < GeminifromDate {
            sign = constellation.Taurus
        }
        if date >= GeminifromDate && date < CancerfromDate {
            sign = constellation.Gemini
        }
        if date >= CancerfromDate && date < LeofromDate {
            sign = constellation.Cancer
        }
        if date >= LeofromDate && date < VirgofromDate {
            sign = constellation.Leo
        }
        if date >= VirgofromDate && date < LibrafromDate {
            sign = constellation.Virgo
        }
        if date >= LibrafromDate && date < ScorpiofromDate {
            sign = constellation.Libra
        }
        if date >= ScorpiofromDate && date < SagittariusfromDate {
            sign = constellation.Scorpio
        }
        if date >= SagittariusfromDate && date < CapricornfromDate {
            sign = constellation.Sagittarius
        }
        return sign
    }
}
