//
//  IsoCountryCodes.swift
//  IsoCountryCodes
//
//  Created by Sidney de Koning on 09/01/15.
//  Copyright (c) 2015 Funky Monkey, www.funky-monkey.nl. All rights reserved.
//

class IsoCountryCodes {

    class func find( key:String ) -> IsoCountryInfo {
        var country = IsoCountries.allCountries.filter(  { $0.alpha2 == key.uppercased() || $0.alpha3 == key.uppercased() || $0.numeric == key } )
        return country[0]
    }

    class func searchByName( calling:String ) -> IsoCountryInfo {
        var country = IsoCountries.allCountries.filter( { $0.calling.uppercased() == calling.uppercased() } )

        return (!country.isEmpty) ? country[0] : IsoCountryInfo(name: "", numeric: "", alpha2: "", alpha3: "", calling: "", currency: "", continent: "")
    }
    
    class func searchByCountryCode( countryCode:String) -> IsoCountryInfo
    {
        var country = IsoCountries.allCountries.filter( { $0.alpha2.uppercased() == countryCode.uppercased() } )
        
        return (!country.isEmpty) ? country[0] : IsoCountryInfo(name: "", numeric: "", alpha2: "", alpha3: "", calling: "", currency: "", continent: "")
    }

    class func searchByNumeric( numeric:String ) -> IsoCountryInfo {
        let country = IsoCountries.allCountries.filter( { $0.numeric == numeric } )

        return (!country.isEmpty) ? country[0] : IsoCountryInfo(name: "", numeric: "", alpha2: "", alpha3: "", calling: "", currency: "", continent: "")
    }

    class func searchByCurrency( currency:String ) -> [IsoCountryInfo] {
        let country = IsoCountries.allCountries.filter(  { $0.currency == currency } )
        return country
    }

    class func searchByCallingCode( calllingCode:String ) -> IsoCountryInfo {
        var country = IsoCountries.allCountries.filter( { $0.calling == calllingCode } )
        return country[0]
    }
}
