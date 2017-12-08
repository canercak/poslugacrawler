class Crawler
    @@metadata = Hash.new
    @@dbServices = []
    @@dbPlaces = []
    @@dbProviders = []
    @@noList = ['work.ua', 'proua.org', 'rio.ua', 'forline.ua', 'klubok.com', 'kartka.com.ua', 'orlada.com', 'kloomba.com', 'board.com.ua', 'freemarket', 'ss.ua', 'ukrmarket.net' 'kidstaff.com.ua' 'flagma.ua', 'uborka-kvartir.com.ua', 'kabanchik.ua', 'pro-poly.ru', 'qimpo.com', 'uborka-kvartir.com.ua', 'olx.ua', 'trovit.com', 'prom.ua', 'rabota.ua', 'bizorg.su', 'moygorod.ua', 'domik.ua', 'youtube.com', 'yandex', 'mys.ua', 'hozmaster.com.ua', 'oneservice.com.ua']
    @@aboutKeys = ['о нас', 'о компании', 'наши контакты', 'информация о нас', 'О нас', 'О компании', 'Наши контакты', 'Информация о нас', 'О Нас','О Компании','Наши Контакты','Информация О Нас','Информация о Нас' ];
    @@hrefAboutKeys = ['about', 'o-nas', 'o_nas', 'about_us', 'about-us', 'o-kompanii', 'o_kompanii', 'kompaniya','About','O-nas','O_nas', 'About_us','About-us','O-kompanii','O_kompanii','Kompaniya'];
    @@serviceKeys = ['наши услуги', 'Послуги', 'услуги', 'наши контакты', 'все услуги','Наши услуги','Услуги', 'Наши контакты', 'Все услуги','Наши Услуги', 'Услуги', 'Наши Контакты', 'Все Услуги'];
    @@hrefServiceKeys = ['nashi-uslugi', 'Nashi-uslugi', 'poslugi', 'services', 'Services', 'Uslugi', 'uslugi' 'Vse-uslugi', 'vse-uslugi'];
    @@contactKeys = ['контакты', 'контакт', 'наши контакты', 'Контакты','Контакт', 'Наши контакты','Контакты', 'Контакт', 'Наши Контакты'];
    @@hrefContactKeys = ['contact', 'kontakty', 'contacts','Contacts', 'kontakt', 'Contact', 'Kontakt'];
    @@kievarray = [
        "http://bolla.kiev.ua",
        "http://prachka.in.ua",
        "http://www.masterhouse.com.ua",
        "http://ukrhimka.kiev.ua"
    ]

    @@proxylist =["197.210.246.30","8080"],
        ["46.225.239.178","8080"],
        ["45.32.185.168","3128"],
        ["47.88.195.233","3128"],
        ["85.143.24.70","80"],
        ["92.222.114.159","3128"],
        ["80.250.55.90","8080"],
        ["217.115.115.249","80"],
        ["80.93.116.226","8080"],
        ["27.254.47.203","80"],
        ["200.52.179.60","80"],
        ["190.112.41.176","9999"],
        ["91.221.233.82","8080"],
        ["197.253.34.22","8080"],
        ["104.131.209.138","3128"],
        ["85.15.121.48","8081"],
        ["51.254.86.25","80"],
        ["138.0.89.102","8080"],
        ["49.207.64.65","8080"],
        ["149.202.248.203","3128"],
        ["128.199.86.57","3128"],
        ["5.189.142.160","3128"],
        ["94.20.21.38","3128"],
        ["37.59.54.54","3128"],
        ["80.232.222.135","3128"],
        ["79.136.65.142","80"],
        ["176.9.134.141","3128"],
        ["213.136.77.246","80"],
        ["92.46.122.98","3128"],
        ["213.136.89.121","80"],
        ["212.1.227.182","80"],
        ["81.187.198.20","80"],
        ["85.26.146.169","80"],
        ["212.120.163.170","80"],
        ["185.91.171.102","8080"],
        ["92.62.225.4","8888"],
        ["185.28.193.95","8080"],
        ["37.205.11.92","4444"],
        ["95.221.96.84","8080"],
        ["212.91.189.162","80"],
        ["184.182.186.130","3128"],
        ["5.135.160.149","3128"],
        ["182.253.201.74","10000"],
        ["218.205.76.131","80"],
        ["183.91.33.43","87"],
        ["94.23.17.157","80"],
        ["138.185.238.66","9001"],
        ["104.236.124.96","3128"],
        ["183.91.33.42","90"],
        ["183.91.33.44","88"]



    require 'mechanize'
    require 'json'
    require 'active_support'
    require 'active_support/core_ext'
    require "unicode_utils"
    require 'mongo'
    require 'active_support/multibyte/unicode'
    require "awesome_print"
    require 'pry'
    require 'geocoder'
    require "execjs"
    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    require 'capybara'
    require 'capybara/poltergeist'
    require 'logging'
    require 'uri'
    require 'launchy'
    require "babosa"
    require 'net/telnet'
    require 'socksify'
    require 'net/http'
    require 'timeout'
    require 'rubygems'
    require 'domainatrix'
    require 'xml-sitemap'
    require "csv"


    @@mongoclient = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'posluga-dev')



    def initialize
        @@mongoclient[:services].find().each do |document|
            @@dbServices.push(document)
        end
        @@mongoclient[:places].find().each do |document|
            @@dbPlaces.push(document)
        end
        @@mongoclient[:providers].find().each do |document|
            @@dbProviders.push(document)
        end
        #analyzePlacesAndServicesToCrawl()
        #crawlGoogle()
        #groupPagesFromDb()

        #crawlPagesFromDb()

        ##crawlPagesFromArray()
        #openUrls()
        #createServiceProviders()
        #removeDuplicateKeywords()
        ##addssltoimages()
        ##removepreproviderimages()
        ##removepreproviderservices()
        createsitemap()
        ##createpromuaexcel()
        ##updateplaces()


        #ap @@metadata
    end
    def connectAgent()
        agent = Mechanize.new do |a|
            a.follow_meta_refresh = true
            a.keep_alive = false
        end
        user_agent = ["Linux Firefox", "Linux Konqueror", "Linux Mozilla", "Mac Firefox", "Mac Mozilla", "Mac Safari 4", "Mac Safari", "Windows Chrome", "Windows IE 6", "Windows IE 7", "Windows IE 8", "Windows IE 9", "Windows Mozilla" ].sample
        agent.user_agent_alias = user_agent
        sleep(1)
        ##agent.set_proxy("37.48.118.90", "13010")
        return agent
    end


    def getSingleGooglePage(link)
        page = nil
        begin
            retries ||= 0
            agent = connectAgent()
            page = agent.get(link)
            if page.blank?
                raise "google kicked, time to retry"
            end
        rescue Exception => e
            ap "getSingleGooglePage retry:" + retries.to_s + ", trying again"
            retry if (retries += 1) < 20
        end
        return page
    end

    def getPageFromLink(link, searchstring)
        page = nil
        formpage = nil
        begin
            retries ||= 0
            # complete_results = Timeout.timeout(5) do
            agent = connectAgent()
            page = agent.get(link)
            if page.blank?
                raise "google kicked, time to retry"
            end
            google_form = page.form('f')
            google_form.q = searchstring
            formpage = agent.submit(google_form, google_form.buttons.first)
            #end
        rescue Exception => e
            if  e.to_s.include?"UTF-8 to WINDOWS-1251"
                ap "UTF-8 to WINDOWS-1251 ERROR on: #{searchstring}"
                return nil
            end
            ap "getPageFromLink retry:" + retries.to_s + ", trying again"
            retry if (retries += 1) < 20
        end
        return formpage
    end


    def removeDuplicateKeywords
        @@mongoclient[:services].find({}).each_with_index do |service, index|
            if service['keywords'] != nil
                if service['keywords'].length > 0
                    if service['keywords'].uniq.length != service['keywords'].length
                        service['keywords'] = service['keywords'].uniq
                        @@mongoclient[:services].update_one({"_id" => service['_id']}, service)
                        puts "updated service: " + service['subcategory']['en']['text']
                    end
                end
            end
        end
    end

    def removepreproviderimages
        @@mongoclient[:preproviders].find({}).each_with_index do |preprovider, index1|
            if preprovider['services'].length > 0
                preprovider['services'].each_with_index do |service, index2|
                    if service['images'].present?
                        if service['images'].length > 14
                            arlen = service['images'].length
                            preprovider['services'][index2]['images'].slice!(14..(arlen-1))
                            @@mongoclient[:preproviders].update_one({"_id" => preprovider['_id']}, preprovider)
                            puts "updated preprovider: " + preprovider['website']
                        end
                    end
                end
            end
        end
    end

    def removepreproviderservices
        @@mongoclient[:preproviders].find({}).each_with_index do |preprovider, index1|
            if preprovider['services'].length > 0 && preprovider['updated'] === true
                array = [];
                servicearray = [];
                preprovider['services'].each_with_index do |s, index2|
                    unless (array.include? s['service'])
                        servicearray.push(s)
                    end
                    array.push(s['service'])
                end
                preprovider['services'] = servicearray
                @@mongoclient[:preproviders].update_one({"_id" => preprovider['_id']}, preprovider)
                puts "updated preprovider: " + preprovider['website']
            end
        end
    end



    def addssltoimages
        @@mongoclient[:services].find({}).each_with_index do |service, index|
            if service['categoryimage'].present?
                url = service['categoryimage']
                uri = URI.parse(url)
                uri.scheme = "https"
                service['categoryimage'] = uri.to_s
                catupdated = true
            end
            if service['subjectimage'].present?
                url = service['subjectimage']
                uri = URI.parse(url)
                uri.scheme = "https"
                service['subjectimage'] = uri.to_s
            end
            if service['image'].present?
                url = service['image']
                uri = URI.parse(url)
                uri.scheme = "https"
                service['image'] = uri.to_s
                catupdated = true
            end
            if service['iconpath'].present?
                url = service['iconpath']
                uri = URI.parse(url)
                uri.scheme = "https"
                service['iconpath'] = uri.to_s
                catupdated = true
            end
            @@mongoclient[:services].update_one({"_id" => service['_id']}, service)
            puts "updated service: " + service['subcategory']['en']['text']
        end
    end


    def createServiceProviders
        @@mongoclient[:crawleddata].find({"created": {'$ne': true},"$where": "this.services.length > 0"}).each_with_index do |data, index|
            ap index
            hasservice = data['services'].length < 15
            ukrsite = !(data['landinglink'].include? "ru")
            servicefound = false
            searched_service = data['service']
            rayon = data['rayon']
            if hasservice == true
                data['services'].each do |service|
                    service_parts = service["subcategoryRu"].split(" ")
                    service_parts.each do |sp|
                        if (searched_service.include? sp)
                            servicefound = true
                            break
                        end
                    end
                end
            end
            if rayon != nil
                if hasservice && ukrsite && servicefound
                    servicelist = []
                    data['services'].each do |service|
                        images = []
                        service['matchedimages'].each do |img|
                            images.push({:url=> img, :_id=> BSON::ObjectId.new})
                        end
                        service['subcategoryRu']  = capitalizeuni(service['subcategoryRu'])
                        s = {:_id=> BSON::ObjectId.new,
                             :service=>  service['id'],
                             :crwkeywords=> service['crwkeywords'],
                             :images=> images,
                             :name=> service['subcategoryRu']  }
                        servicelist.push(s)
                    end
                    foundplace = {}
                    place = downcaseuni(data['place'])
                    if data["addresslist"].present?
                        addresslist = downcaseuni(data["addresslist"])
                        if addresslist.include? place
                            xrayon = data['place'] + " город"
                            places = @@mongoclient[:places].find({"rayon.ru": xrayon })
                            if places.count > 0
                                foundplace["oblast"] = places.to_a[0]["oblast"]
                                foundplace["rayon"] = places.to_a[0]["rayon"]
                                if data['rayon'].present?
                                    places2 = @@mongoclient[:places].find({"rayon.ru": foundplace["rayon"]["ru"], "oblast.ru": foundplace["oblast"]["ru"] })
                                    ryn = data['rayon'].remove(" район")
                                    places2.each do |p|
                                        if p["gorad"].present?
                                            if (p["gorad"]["ru"].include? ryn) || (p["gorad"]["uk"].include? ryn)
                                                foundplace["gorad"] = p['gorad']
                                                break
                                            end
                                        end
                                    end
                                    if foundplace["gorad"].blank?
                                        places2.each do |p|
                                            if p["rayongorad"].present?
                                                if (p["rayongorad"]["ru"].include? ryn) || (p["rayongorad"]["uk"].include? ryn)
                                                    foundplace["rayongorad"] = p['rayongorad']
                                                    foundplace["gorad"] = p['gorad']
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end

                        end
                    end
                    preprovider = {
                        :phone => data['phones'][0] || nil,
                        :company=>  data['companyname'] || nil ,
                        :email=>  data['email']|| nil,
                        :firstname=> nil,
                        :lastname=> nil,
                        :phonelist=> data['phones']|| nil,
                        :phone2=> data['phones'][1] || nil,
                        :landline=> data['phones'][2] || nil,
                        :website=> data['landinglink'] || nil,
                        :description=> data['description'] || nil,
                        :photo=> data['logo'] || nil,
                        :created=> false,
                        :address=> data['addresslist'] || nil,
                        :createdAt=> DateTime.now,
                        :updatedAt=> DateTime.now,
                        :updated => false,
                        :created=> false,
                        :gorad=> foundplace['gorad'] || nil,
                        :rayon=> foundplace['rayon'] || nil,
                        :oblast=> foundplace['oblast'] || nil,
                        :rayongorad=> foundplace['rayongorad'] || nil,
                        :placeid=> foundplace['_id'] || nil,
                        :geocodedaddress=> data['geocodedAddress'] || nil,
                        :businesstype=> {:objectid=> 2, :name=> "Company"},
                    :services=> servicelist }
                    found = @@mongoclient[:preproviders].find({:website=>data['landinglink']})
                    if found.count == 0
                        @@mongoclient[:preproviders].insert_one(preprovider)
                        data['created'] = true;
                        @@mongoclient[:crawleddata].update_one({"_id" => data['_id']}, data)
                    end
                end
            end
        end
    end


    def openUrls
        @@mongoclient[:crawleddata].find({:services=>[]}, :timeout => false).each_with_index do |service, index|
            if index >= 700 && index <= 750
                sleep(0.2)
                ap "openingpage: " + service['servicelink']
                ap service['searchstring']
                Launchy.open(service['servicelink'])
            end
        end

    end

    def crawlPagesFromArray
        searchstring = ""
        gorad = "Киев"
        oblast =  "Киевская область"
        @@kievarray.each do |page|
            crawlPage(page, gorad, oblast, searchstring)
        end
    end
    def  groupPagesFromDb
        counter = 0
        begin
            retries ||= 0
            400.times do
                crawlarray = @@mongoclient[:crawlarray].aggregate([ { '$sample': { size: 1000 } }, {'$match': {'grouped': {'$ne': true}}}])
                crawlarray.each do |document|
                    counter = counter + 1
                    ap "counter is: " + counter.to_s
                    searchstring = document['searchstring']
                    ap "working for: " + searchstring
                    document['searchresults'].each_with_index do |element, index|
                        elm = Domainatrix.parse(element[:url])
                        found = @@mongoclient[:groupedcrawldata].find({:domain=>elm.domain}, :timeout => false)
                        if found.count == 0
                            data = {:domain=> elm.domain, :pages=>[{:pageurl=>elm.url, :place=>document[:place], :service=>document[:service], :searchstring=>document[:searchstring]}]}
                            @@mongoclient[:groupedcrawldata].insert_one(data)
                        else
                            founddata = found.map{|a|a}[0]
                            foundpage = false
                            founddata["pages"].each do |page|
                                if (page["pageurl"] == elm.url)
                                    foundpage = true
                                end
                            end
                            if (foundpage == false)
                                founddata["pages"].push({:pageurl=>elm.url, :place=>document[:place], :service=>document[:service], :searchstring=>document[:searchstring]})
                                @@mongoclient[:groupedcrawldata].update_one({"_id" => founddata['_id']}, founddata)
                            end
                        end
                    end
                    document[:grouped] = true
                    @@mongoclient[:crawlarray].update_one({"_id" => document['_id']}, document)
                end
            end
        rescue Exception => e
            ap "MONGODB PROBLEM RETRY retry:" + retries.to_s + ", trying again"
            sleep(10)
            retry if (retries += 1) < 40
        end
    end

    def crawlPagesFromDb
        @@metadata = {}

        begin
            retries ||= 0
            # crawldata = @@mongoclient[:groupedcrawldata].aggregate(
            #     [
            #         { '$sample': { size: 4000 } },
            #         {'$project': {
            #              size_of_pages: {'$size': "$pages"}
            #          }
            #          },
            #         {'$match': {'analyzed': {'$ne': true}, "size_of_pages": {'$gt': 1}}}
            # ])
            crawldata = @@mongoclient[:groupedcrawldata].aggregate([ { '$sample': { size: 4000 } }, {'$match':  {'analyzed': {'$ne': true}, 'pages.0': {"$exists":true}}}])
            #crawldata = @@mongoclient[:groupedcrawldata].find({pages: {"$exists":true}, analyzed: {"$ne":true}, "$where":"this.pages.length<10"})
            crawldata.each do |data|
                pages = data['pages']
                pd = Domainatrix.parse(pages[0]["pageurl"])
                if (pd.public_suffix == 'ru')
                    puts 'found a ru website, skipping'
                    data["analyzed"] = true
                    @@mongoclient[:groupedcrawldata].update_one({"_id" => data['_id']}, data)
                    next
                end
                if (pages.length >14 )
                    puts 'found a page bigger than 14, skipping'
                    next
                end
                pages.each do |document|
                    pg = Domainatrix.parse(document["pageurl"])
                    domain = pg.domain
                    host = pg.host
                    visitlink = document["pageurl"]
                    page = pg.scheme + "://" + pg.host
                    place = document["place"]
                    service = document["service"]
                    searchstring = document["searchstring"]
                    begin
                        found = @@mongoclient[:crawleddata].find({:host=>host})
                        if found.count == 0
                            ap "connecting to page: " + page
                            groupedpages = pages
                            createmetadata(domain,visitlink, page, place, service, searchstring, groupedpages)
                            landingpagelinks = getpagelinks(page)
                            analyzeContactLink(landingpagelinks, page)
                            analyzeAboutLink(landingpagelinks, page)
                            servicelink = analyzeServiceLink(landingpagelinks, page)
                            servicepagelinks = getpagelinks(servicelink)
                            analyzeServicePageLinks(servicepagelinks, page)
                            collectImagesFromServicePages(page)
                            collectContactDetails(page)
                            collectNameDescription(page)
                            writeMetadata(page)
                        else
                            ap "skipping already analyzed page: " + page
                        end
                    rescue Exception => e
                        ap "error on WHOLE PROCESS -THIS CANT BE CHECK THE CODE: " +  page
                        ap e
                    end
                end
                data["analyzed"] = true
                @@mongoclient[:groupedcrawldata].update_one({"_id" => data['_id']}, data)
            end
        rescue Exception=>e
            ap "retry:" + retries.to_s + ", trying again"
            retry if (retries += 1) < 100
        end

    end

    def writeMetadata(page)
        @@mongoclient[:crawleddata].insert_one(@@metadata)
        ap "METADATA WRITTEN"
    end

    def analyzePlacesAndServicesToCrawl
        ap "collecting searchstigngs"
        crawlarray= []
        @@dbPlaces.each do |p|
            place = "";
            if (p['rayon']['ru'].include? " город")
                place = p['rayon']['ru'].remove " город"
            else
                place = (p['oblast']['ru'] + ' ' + p['rayon']['ru'] + ' ' + (p['gorad'] != nil ? p['gorad']['ru'] : '') + ' ' + (p['rayongorad'] != nil ? p['rayongorad']['ru'] : '')).strip
            end
            if !(p['rayon']['ru'].include? " город")
                @@dbServices.each do |s|
                    place = place.strip
                    service = s['subcategory']['ru']['text']
                    searchstring = "#{service} #{place}"
                    found = @@mongoclient[:crawlarray].find(:place=> place, :service=>service)
                    if found.count == 0
                        element = {:place=> place, :service=>service, :searchstring=> "#{service} #{place} Украина", :searchresults=>[]}
                        @@mongoclient[:crawlarray].insert_one(element)
                    end
                end
            end
        end
    end
    def crawlGoogle
        begin
            retries ||= 0
            4000.times do
                crawlarray = @@mongoclient[:crawlarray].aggregate([ { "$sample": { size: 2000 } }, {'$match':  {'grouped': {'$ne': true}}}]  )
                crawlarray.each do |elm|
                    finalsearchstring = elm['searchstring']
                    if elm["searchresults"].blank?
                        ap "SEARCHING: #{finalsearchstring}"
                        results = searchOnGoogle(finalsearchstring)
                        elm["searchresults"] = results
                        @@mongoclient[:crawlarray].update_one({"_id" => elm['_id']}, elm)
                    else
                        ap "ALREADY SEARCHED: #{finalsearchstring}"
                    end
                end
            end
        rescue Exception => e
            ap "MONGODB PROBLEM RETRY retry:" + retries.to_s + ", trying again"
            retry if (retries += 1) < 400
        end
        ap "finished crawling google"
    end

    def searchOnGoogle(searchstring)
        page = getPageFromLink('http://www.google.com.ua', searchstring)
        if page != nil
            companylinks = []
            googlelinks = [page.uri.to_s]
            page.links.each_with_index do |link, index|
                if link.href.to_s =~/url.q/
                    str=link.href.to_s
                    strList=str.split(%r{=|&})
                    url=strList[1]
                    if url.length < 250 && (url.include? '://')
                        companylinks.push({:url=>url, :text=> link.text.to_s})
                    end
                end
            end
            page.links.each do |link|
                for i in 2..5
                    if link.text.to_s==i.to_s && !(googlelinks.include? link.text.to_s)
                        googlelinks.push("http://www.google.com.ua" +link.href.to_s)
                    end
                end
            end
            googlelinks.each_with_index do |googlelink, index|
                if index != 0
                    webpage = getSingleGooglePage(googlelink)
                    webpage.links.each do |link|
                        if link.href.to_s =~/url.q/
                            str=link.href.to_s
                            strList=str.split(%r{=|&})
                            url=strList[1]
                            if url.length < 250 && (url.include? '://')
                                companylinks.push({:url=>url, :text=> link.text.to_s})
                            end
                        end
                    end
                end
            end
            return makeCompanyLinksBetter(companylinks)
        else
            return []
        end
    end

    def makeCompanyLinksBetter(links)
        finallinks = []
        links.each do |link|
            includeNo = false
            @@noList.each do |item|
                if (link[:url].include? item)
                    includeNo = true
                    break
                end
            end
            if includeNo == false
                finallinks.push(link)
            end
        end
    end

    def normalizeLink(link, page)
        finallink = link
        if !(link.include? '://')
            if link.chars.first != '/'
                finallink =  page + '/' + link
            else
                finallink = page + link
            end
        end
        return finallink
    end

    def downcaseuni(string)
        x = string
        if !x.valid_encoding?
            x = x.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8').mb_chars.downcase
        else
            x = x.mb_chars.downcase
        end
        return x.to_s
    end

    def capitalizeuni(string)
        x = string
        if !x.valid_encoding?
            x = x.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8').mb_chars.capitalize
        else
            x = x.mb_chars.capitalize
        end
        return x.to_s
    end

    def createmetadata(domain,visitlink, page, place, service, searchstring,groupedpages)
        @@metadata = {:place =>place,
                    :searchstring=> searchstring,
                    :service => service,
                    :groupedpages=> groupedpages,
                    :domain=>domain,
                    :visitlink=> visitlink,
                    :landinglink=> page,
                    :contactlink=> nil,
                    :aboutlink=> '',
                    :servicelink=> '',
                    :services=> [],
                    :companyname => nil,
                    :description => nil,
                    :addresslist=> [],
                    :phones => [],
                    :rayon=> nil,
                    :geocodedAddress => nil }
    end

    def getpagelinks(page)
        begin
            agent = Mechanize.new do |a|
                a.follow_meta_refresh = true
                a.keep_alive = false
            end
            linkarray = Array.new
            webpage = agent.get(page)
            webpage.links.each do |link|
                x =link.text
                if(x != nil && link.href !=nil)
                    x = downcaseuni(x)
                    linkhash = Hash["text" =>x , "href" => link.href]
                    linkarray.push(linkhash)
                end
            end
            return linkarray
        rescue Exception => e
            ap "error on WHOLE PROCESS -THIS CANT BE CHECK THE CODE: " +  page
            ap e
            return []
        end
    end

    def analyzeAboutLink(elements, page)
        begin
            aboutlink = nil
            elements.each do |elm|
                if @@aboutKeys.include? elm['text']
                    aboutlink = elm['href']
                    break
                else
                    if (defined? elm['href'] )
                        @@hrefAboutKeys.each do |key|
                            if elm['href'].include? key
                                aboutlink = elm['href']
                                break
                            end
                        end
                    end
                end
            end
            if aboutlink.present?
                aboutlink = normalizeLink(aboutlink, page)
                @@metadata[:aboutlink] = aboutlink
            else
                @@metadata[:aboutlink] = page
            end
        rescue Exception => e
            ap "error on analyzeAboutLink" +  page
            ap e
        end
    end

    def analyzeContactLink(elements, page)
        begin
            contactlink =nil
            elements.each do |elm|
                if @@contactKeys.include? elm['text']
                    contactlink = elm['href']
                    break
                else
                    if (defined? elm['href'] )
                        @@hrefContactKeys.each do |key|
                            if elm['href'].include? key
                                contactlink = elm['href']
                                break
                            end
                        end
                    end
                end
            end
            if contactlink.present?
                contactlink = normalizeLink(contactlink, page)
                @@metadata[:contactlink] = contactlink
            end
        rescue Exception => e
            ap "error on analyzeContactLink" +  page
            ap e
        end
    end

    def analyzeServiceLink(elements, page)
        begin
            servicelink = nil
            elements.each do |elm|
                if @@serviceKeys.include? elm['text']
                    servicelink = elm['href']
                    break
                else
                    if (defined? elm['href']  )
                        @@hrefServiceKeys.each do |key|
                            if elm['href'].include? key
                                servicelink = elm['href']
                                break
                            end
                        end
                    end
                end
            end
            if servicelink != nil
                servicelink = normalizeLink(servicelink, page)
            else
                servicelink = page
            end
            @@metadata[:servicelink] = servicelink
            return servicelink
        rescue Exception => e
            ap "error on analyzeServiceLink" +  page
            ap e
            return nil
        end
    end


    def analyzeServicePageLinks(links,page)
        begin
            links.each do |link|

                linktext = downcaseuni(link['text'].strip)
                @@dbServices.each do |service|
                    begin
                        subcategoryRu =  downcaseuni( service['subcategory']['ru']['text'])
                        subcategoryUk =   downcaseuni( service['subcategory']['uk']['text'])
                        alreadyexists = false
                        @@metadata[:services].each do |ms|
                            if ms[:subcategoryRu] == subcategoryRu
                                alreadyexists = true
                                break
                            end
                        end
                        ##if alreadyexists == false && (linktext == subcategoryRu)
                        if alreadyexists == false && (linktext.include? subcategoryRu)
                            href = normalizeLink(link['href'], page)
                            @@metadata[:services].push(Hash[:matchedimages => [],
                                                            :matchedhref=> href ,
                                                            :matchedname=> linktext,
                                                            :id=> service['_id'],
                                                            :categoryid=> service['categoryid'],
                                                            :subjectid=> service['subjectid'],
                                                            :subcategoryid=> service['subcategoryid'],
                                                            :subcategoryRu=> subcategoryRu,
                                                            :subcategoryUk=> subcategoryUk,
                                                            :crwkeywords=> service['crwkeywords']
                                                            ])
                            break
                        end
                    rescue Exception=> e
                        #binding.pry
                    end
                end
            end
            links.each do |link|
                linktext = downcaseuni(link['text'].strip)
                @@dbServices.each do |service|
                    subcategoryRu =  downcaseuni( service['subcategory']['ru']['text'])
                    subcategoryUk =   downcaseuni( service['subcategory']['uk']['text'])
                    alreadyexists = false
                    @@metadata[:services].each do |ms|
                        if ms[:subcategoryRu] == subcategoryRu
                            alreadyexists = true
                            break
                        end
                    end
                    foundkeyword = false
                    service['crwkeywords'].each do |keyword|
                        #if (linktext== keyword)
                        if (linktext.include? keyword)
                            foundkeyword = true
                            break
                        end
                    end
                    if  alreadyexists == false &&  foundkeyword == true
                        href = normalizeLink(link['href'], page)
                        @@metadata[:services].push(Hash[:matchedimages => [],
                                                        :matchedhref=> href ,
                                                        :matchedname=> linktext,
                                                        :id=> service['_id'],
                                                        :categoryid=> service['categoryid'],
                                                        :subjectid=> service['subjectid'],
                                                        :subcategoryid=> service['subcategoryid'],
                                                        :subcategoryRu=> subcategoryRu,
                                                        :subcategoryUk=> subcategoryUk,
                                                        :crwkeywords=> service['crwkeywords']
                                                        ])
                        break
                    end
                end
            end
        rescue Exception => e
            ap "error on analyzeServicePageLinks" +  page
            ap e
        end
    end

    def collectImagesFromServicePages(page)
        begin
            imageNoKeys = ['icons', 'data:image', 'header', 'footer', 'icon', 'facebook', 'twitter', 'google', 'socials', 'languages', 'yandex', 'rambler', 'c.hit', 'language', 'instagram', 'vks', 'arrow', 'logo']
            logo = nil
            @@metadata[:services].each_with_index  do |service, index|
                servicepage = service[:matchedhref]
                agent = Mechanize.new do |a|
                    a.follow_meta_refresh = true
                    a.keep_alive = false
                end
                imgarray = Array.new
                webpage = agent.get(servicepage)
                webpage.search('img').each do |a|
                    if a['src'] != nil
                        if (imageNoKeys.any? { |s| (a['src'].include? s) }) == false
                            thelink = normalizeLink(a['src'], page)
                            if (imgarray.any? { |x| (x == thelink) }) == false
                                imgarray.push(thelink)
                            end
                        end
                        if logo == nil && (a['src'].include? 'logo')
                            logo = normalizeLink(a['src'], page)
                        end
                    end
                end
                @@metadata[:services][index][:matchedimages] = imgarray
            end
            @@metadata[:logo] = logo
        rescue Exception => e
            ap "error on collectimagesfromservicepages" +  page
            ap e
        end
    end

    def collectEmail(page)
        begin
            email = nil
            contactpage = @@metadata[:contactlink]
            if contactpage != nil

                agent = Mechanize.new do |a|
                    a.follow_meta_refresh = true
                    a.keep_alive = false
                end
                webpage = agent.get(contactpage)
                texts = webpage.search('p', 'h1', 'h2', 'h3', 'h4',  'li', 'td')
                textArray = Array.new
                texts.each do |text|
                    string = text.text
                    string = downcaseuni(string)
                    string = string.gsub(/\s+/, ' ').strip
                    if string.include? '@'
                        reg = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
                        email = string[reg]
                        break;
                    end
                end

            else
                ap 'contactpage is nil on collectEmail for page: ' + page
            end
            @@metadata[:email] = email
        rescue Exception => e
            ap "error on collectEmail" +  page
            ap e
        end
    end

    def collectPhones(page)
        begin
            regexArray = [/\([0-9]+\) [0-9]+-[0-9]+-[0-9]+/i, #(066) 081-27-37
                        /\([0-9]+\) [0-9]+ [0-9]+/i, #(044) 5000 400
                        /\([0-9]+\) [0-9]+ [0-9]+ [0-9]+/i,  #(099) 647 63 33
                        /\([0-9]+\)[0-9]+-[0-9]+-[0-9]+/i, #(044)338-97-92
                        /[0-9]+-[0-9]+-[0-9]+-[0-9]+|\+[0-9]+ [0-9]+ [0-9]+ [0-9]+-[0-9]+-[0-9]+/i, #+3 8 044 222-3-222"
                        /\+[0-9]+ \([0-9]+\) [0-9]+-[0-9]+-[0-9]+/i, #+38 (093) 351-7-700
                        /\+[0-9]+ \([0-9]+\) [0-9]+ [0-9]+/i, #+38 (044) 223 4107
                        /\+[0-9]+ \([0-9]+\)[0-9]+-[0-9]+/i, #+38 (093) 351-7-700
                        /\+[0-9]+ [0-9]+ [0-9]+-[0-9]+-[0-9]+/i, #+38 (044) 223 4107
                        /\+[0-9]+ \([0-9]+\) [0-9]+ [0-9]+/i,
                        /[0-9]+-[0-9]+-[0-9]+-[0-9]+|\+[0-9]+ [0-9]+ [0-9]+ [0-9]+-[0-9]+-[0-9]+/i] #+38 (093) 351-7-700
            contactpage = @@metadata[:contactlink]
            email = nil
            if contactpage != nil
                agent = Mechanize.new do |a|
                    a.follow_meta_refresh = true
                    a.keep_alive = false
                end
                webpage = agent.get(contactpage)
                texts = webpage.search('p','li', 'td')
                textArray = Array.new
                foundphones = []
                texts.each do |text|
                    string = text.text
                    string = downcaseuni(string)
                    string = string.gsub(/\s+/, ' ').strip
                    if string != "\r\n\t\r\n"
                        regexArray.each do |regex|
                            phone = string.scan(regex)
                            if phone.include?"+380"
                                phone.slice! "+380"
                            end
                            if phone.include?"+38"
                                phone.slice! "+38"
                            end
                            foundphones.push(phone)
                        end
                    end
                end
                foundphones = foundphones.flatten.uniq
                #http://dialcode.org/Europe/Ukraine/  #https://en.wikipedia.org/wiki/List_of_dialling_codes_in_Ukraine
                @@metadata[:phones] = foundphones

            else
                ap 'contactpage is nil on collectEmail for page: ' + page
            end
        rescue Exception => e
            ap "error on collectPhones" +  page
            ap e
        end
    end

    def collectAddress(page)
        begin
            regexArray = [/ул\./i]
            contactpage = @@metadata[:contactlink]
            regexarray1 = [/переулок /, /бул-р /, /пр-т\. /, /ул\. /, /ул\./, /улица /,  /пр\. /,/пл\. /, /г\. /, /проспект /, /просп\./, /корпус /, /этаж /,/вул\./, /вулиця /, /бульвар/,
                         /Ул\. /, /Улица /, /Пр\. /, /Пл\. /, /Г\. /, /Проспект /, /Просп\./, /Корпус /, /Этаж /,/вул\./, /Вулиця /, /Бульвар/]
            regexarray2 = [/ д\. /,/ Д\. / ]
            addressList = []
            if contactpage != nil

                agent = Mechanize.new do |a|
                    a.follow_meta_refresh = true
                    a.keep_alive = false
                end
                webpage = agent.get(contactpage)
                texts = webpage.search('p', 'td', 'dd', 'div', 'li', 'address')
                textArray = Array.new
                texts.each do |text|
                    string = nil
                    begin
                        string = text.text.gsub(/\s+/, ' ').strip
                    rescue
                        next
                    end
                    regexarray1.each do |regex|
                        if  string[regex].present?
                            if !addressList.flatten.uniq.include? string
                                addressList.push(string)
                            end
                        end
                    end
                end
                addressList = addressList.flatten.uniq
                if addressList.empty?
                    texts.each do |text|
                        string = text.text.gsub(/\s+/, ' ').strip
                        regexarray2.each do |regex|
                            if  string[regex].present?
                                if !addressList.flatten.uniq.include? string
                                    addressList.push(string)
                                end
                            end
                        end
                    end
                end
                makeAddressBetter(addressList, page)

            else
                ap 'contactpage is nil on collectEmail for page: ' + page
            end
        rescue Exception => e
            ap "error on collectAddress" +  page
            ap e
        end
    end

    def searchGeo(string)
        Geocoder.configure(
            :lookup => :google,
            :language=> 'ru',
            :api_key => ['AIzaSyAvgmwG0Ko5D1mxYMHz_3ti06EQnHnp6Ek','AIzaSyDspDD70EXleIcV2t2pH-vUV-YkloEDmBQ', 'AIzaSyDrffmY_KSZbeHvGHjUoytXiyAxEk_4ckk', 'AIzaSyA5d1cl5xE9RDPaknPEVL7D3MkP6v0lKcU'].sample,
            :timeout => 10
        )
        return Geocoder.search(string)
    end

    def geocodeRayon(foundtext, page)
        geocodedAddress = searchGeo(foundtext)
        if geocodedAddress.present?
            begin
                rayon = geocodedAddress[0].data["address_components"][1]["long_name"]
                if rayon.include? "район"
                    @@metadata[:addresslist] = foundtext
                    @@metadata[:geocodedAddress] = geocodedAddress[0].data
                    @@metadata[:rayon] = rayon
                    return true
                else
                    rayon = geocodedAddress[0].data["address_components"][2]["long_name"]
                    if rayon.include? "район"
                        @@metadata[:addresslist] = foundtext
                        @@metadata[:geocodedAddress] = geocodedAddress[0].data
                        @@metadata[:rayon] = rayon
                        return true
                    else
                        rayon = geocodedAddress[0].data["address_components"][3]["long_name"]
                        if rayon.include? "район"
                            @@metadata[:addresslist] = foundtext
                            @@metadata[:geocodedAddress] = geocodedAddress[0].data
                            @@metadata[:rayon] = rayon
                            return true
                        else
                            rayon = geocodedAddress[0].data["address_components"][4]["long_name"]
                            if rayon.include? "район"
                                @@metadata[:addresslist] = foundtext
                                @@metadata[:geocodedAddress] = geocodedAddress[0].data
                                @@metadata[:rayon] = rayon
                                return true
                            else
                                return false
                            end
                        end
                    end
                end
            rescue
                return false
            end
        else
            return false
        end
    end

    def makeAddressBetter(addressList, page)
        ### try the first found address
        foundtext = addressList[0]
        if foundtext != nil && (foundtext.include? ' тел')
            foundtext = foundtext.split(' тел')[0]
        end
        if foundtext != nil && (foundtext.include? ' Моб')
            foundtext = foundtext.split(' Моб')[0]
        end
        if foundtext != nil && (foundtext.include? ' Тел')
            foundtext = foundtext.split(' Тел')[0]
        end
        if foundtext != nil && (foundtext.include? '(') && (foundtext.include? ')')
            foundtext = foundtext.gsub(/\(.*\)/, "")
        end
        if foundtext != nil && (foundtext.include? 'Адрес ')
            foundtext = foundtext.split('Адрес ').last
        end
        if foundtext != nil && (foundtext.include? 'Адрес: ')
            foundtext = foundtext.split('Адрес: ').last
        end
        if foundtext != nil && (foundtext.include? 'Наши контакты')
            foundtext = foundtext.split('Наши контакты')[0]
        end
        if foundtext != nil && !(foundtext.include? @@metadata[:place])
            foundtext = foundtext + ' ' + @@metadata[:place]
        end

        if foundtext != nil && geocodeRayon(foundtext, page) == false
            if (foundtext.include? 'eval')
                foundtext = foundtext.split('eval')[0]
            end
            if foundtext.include? "ул."
                foundtext = "ул. " + foundtext.split('ул. ').last
            end
            if foundtext != nil && !(foundtext.include? @@metadata[:place])
                foundtext = foundtext + ' ' + @@metadata[:place]
            end
            if  foundtext != nil && geocodeRayon(foundtext, page) == false
                geocodeSuccess = false
                addressList.each_with_index do |address, index|
                    if !(address.include? "@") && index != 0
                        if (address.include? "ул.")
                            foundtext = "ул. " + address.split('ул. ').last
                            if !(foundtext.include?  @@metadata[:place])
                                foundtext = foundtext + ' ' + @@metadata[:place]
                            end
                        end
                        if (address.include? "улица ")
                            foundtext = "улица " + address.split('улица ').last
                            if !(foundtext.include?  @@metadata[:place])
                                foundtext = foundtext + ' ' + @@metadata[:place]
                            end
                        end
                        if (address.include? "Улица ")
                            foundtext = "Улица " + address.split('Улица ').last
                            if !(foundtext.include?  @@metadata[:place])
                                foundtext = foundtext + ' ' + @@metadata[:place]
                            end
                        end
                        if (address.include? "Адрес: ")
                            foundtext = address.split('Адрес: ').last
                            if !(foundtext.include?  @@metadata[:place])
                                foundtext = foundtext + ' ' + @@metadata[:place]
                            end
                        end
                        if geocodeRayon(foundtext, page) == true
                            geocodeSuccess = true
                            break
                        end
                    end
                end
                if geocodeSuccess == false && foundtext != nil
                    if foundtext.include? "офис "
                        foundtext = foundtext.split('офис ')[0]
                    end
                    if (foundtext.include?  @@metadata[:place])
                        foundtext = foundtext.split(@@metadata[:place]).last
                    end
                    if geocodeRayon(foundtext, page) == true
                        geocodeSuccess = true
                    else
                        @@metadata[:addresslist] = foundtext
                    end
                end
            end
        end

        return foundtext
    end

    def collectContactDetails(page)
        collectEmail(page)
        collectPhones(page)
        collectAddress(page)
    end

    def collectNameDescription(page)
        begin
            aboutpage = @@metadata[:aboutlink]
            foundname ={:text=>nil, :matchedrgx=>nil}

            agent1 = Mechanize.new do |a|
                a.follow_meta_refresh = true
                a.keep_alive = false
            end
            webpage1 = agent1.get(aboutpage)
            textsh = webpage1.search('h1', 'h2', 'h3', 'h4')
            foundname = collectName(textsh)
            if foundname[:text] == nil
                textsp = webpage1.search('p')
                foundname = collectName(textsp)
            end
            if foundname[:text] != nil
                @@metadata[:companyname] = checkNoNeedChars(foundname[:text])
            end
            textsp = webpage1.search('p')
            founddesc = collectDesc(textsp, foundname)
            @@metadata[:description] = founddesc
        rescue Exception => e
            ap "error on collectNameDescription" +  page
            ap e
        end

    end

    def checkNoNeedChars(string)
        lastchar = string[-1, 1]
        if lastchar == ':'
            return string.remove(':')
        end
        if lastchar == '.'
            return string.remove('.')
        end
        return string
    end

    def collectName(texts)
        foundname ={:text=>nil, :matchedrgx=>nil}
        tagtexts = texts.map{|a| a.text}
        tagtexts.each do |text|
            string = text
            string = downcaseuni(string)
            string = string.gsub(/\s+/, ' ').strip
            firstarray = [{:exp=> /компании «([^\s]+.*?)\»/i, :init=> "компании «", :end=> "»"},
                        {:exp=>/компании “(.*?.*)\”/i, :init=> "компании “", :end=> "”"},
                        {:exp=>/компании "(.*?.*)\"/i, :init=> 'компании "', :end=> '"'},
                            {:exp=>/компания «([^\s]+.*?)\»/i, :init=> 'компания «', :end=> '»'},
                            {:exp=>/компания “(.*?.*)\”/i, :init=> "компания “", :end=> "”"},
                            {:exp=>/компания "(.*?.*)\"/i, :init=> 'компания "', :end=> '"'},
                            {:exp=>/компанию «([^\s]+.*?)\»/i, :init=> 'компанию «', :end=> '»'},
                            {:exp=>/компанию “(.*?.*)\”/i, :init=> "компанию “", :end=> "”"},
                            {:exp=>/компанию "(.*?.*)\"/i, :init=> 'компанию "', :end=> '"'},
                            {:exp=>/ооо «([^\s]+.*?)\»/i, :init=> 'ооо «', :end=> '»'},
                            {:exp=>/ооо ”([^\s]+.*?)\”/i, :init=> "ооо “", :end=> "”"},
                            {:exp=>/ооо "(.*?.*)\"/i, :init=> 'ооо "', :end=> '"'}]
            secondarray = [{:exp=> /компании\s+([^\s]+)/i, :init=> "компании ", :end=> " "},
                        {:exp=>/компания\s+([^\s]+)/i, :init=> "компания ", :end=> " "},
                        {:exp=>/компанию\s+([^\s]+)/i, :init=> "компанию ", :end=> " "},
                        {:exp=> /компанией\s+([^\s]+)/i, :init=>"компанией ", :end=>" "}]
            if string != "\r\n\t\r\n" 
                firstarray.each do |regex| 
                    found = string[regex[:exp]]
                    if found != nil 
                        txt = found.split(regex[:init])[1].split(regex[:end])[0]
                        foundname = {:text=> txt, :matchedrgx=> regex}
                        break
                    end
                end 
            end 
            if foundname[:text] == nil
                secondarray.each do |regex| 
                    found = string[regex[:exp]]
                    if found != nil 
                        txt = found.split(regex[:init])[1].split(regex[:end])[0]
                        foundname = {:text=> txt, :matchedrgx=> regex}
                        break;
                    end
                end 
            end
        end
        return foundname
    end

    def collectDesc(textsp, foundname)
        finaltext = nil
        tagtexts = textsp.map{|a| a.text}.sort_by {|x| x.length}.reverse!  
        tagtexts.each do |string| 
            string = downcaseuni(string) 
            string = string.gsub(/\s+/, ' ').strip  
            if foundname[:text] != nil && string != ""
                searchstring = foundname[:text] #+ foundname[:matchedrgx][:end]
                if (string.include? searchstring) && string.length > 50
                    finaltext = string 
                    break
                end 
            end 
        end 
        if finaltext == nil  
            finaltext = tagtexts[0]  
        end 
        return finaltext
    end
 

   def select_keywords(service)
    keywords = service['keywords'].present? ? service['keywords'].map { |i| i.to_s}.join(",") : ""
    s = keywords.split(" ").each_with_object("") {|x,ob| break ob unless (ob.length + " ".length + x.length <= 200);ob << (" " + x)}.strip
    return s
   end


    def createpromuaexcel 
 
    # goradarray = []
    #     CSV.open("placesWithGorods.csv", "wb") do |csv|
    #         csv << ["Oblast", "Rayon", "Gorad", "Rayongorad", "oblastslug", "rayonslug"] 
    #         @@dbPlaces.each do |place|  
    #             slug = place['rayon']['slug']
    #             if slug.include? "-gorod" 
    #                 unless goradarray.include? slug 
    #                     csv << [place['oblast']['ru'], place['rayon']['ru'], (place['gorad'].present? ? place['gorad']['ru'] : ""), (place['rayongorad'].present? ? place['rayongorad']['ru'] : ""), (place['oblast']['slug']), (place['rayon']['slug'])]
    #                     goradarray.push(slug)
    #                 end
    #             end
    #         end
    #     end

 
        CSV.open("promua.csv", "wb") do |csv|
            csv << ["Код_товара","Название_позиции","Ключевые_слова","Описание","Тип_товара","Цена","Валюта","Единица_измерения","Минимальный_объем_заказа","Оптовая_цена","Минимальный_заказ_опт","Ссылка_изображения","Наличие","Количество","Номер_группы","Название_группы","Адрес_подраздела","Возможность_поставки","Срок_поставки","Способ_упаковки","Уникальный_идентификатор","Идентификатор_товара","Идентификатор_подраздела","Идентификатор_группы","Производитель","Гарантийный_срок","Страна_производитель","Скидка","ID_группы_разновидностей","Название_Характеристики","Измерение_Характеристики","Значение_Характеристики"] 
            placelistpromua.each do |place| 
                @@dbServices.each do |service|  
                    if service['promua'] == true 
                        category = service['category']['ru']['text'] 
                         puts category
                        Код_товара = rand(10_000_000-1_000_000)+1_000_000
                        Название_позиции  = service['subcategory']['ru']['text']
                        Ключевые_слова = select_keywords(service)
                        Описание= promuahtml(place[:rayon], Название_позиции, service['_id'], place[:oblastslug], place[:rayonslug])
                        Тип_товара = "s"
                        Цена = "100"
                        Валюта = "UAH"
                        Единица_измерения ="услуга"
                        Минимальный_объем_заказа = ""
                        Оптовая_цена = ""
                        Минимальный_заказ_опт = "" 
                        Ссылка_изображения = service['subjectimage'];
                        if (service['categoryimage'].present?)
                            Ссылка_изображения = service['categoryimage']
                        else
                            if service['subjectimage'].blank?
                                  Ссылка_изображения  = "https://posluga.ua/assets/images/8289144b.poslugalogo.png"
                            end
                        end 
                        Наличие = "@"
                        Количество  = ""
                        Номер_группы = place[:number]
                        Название_группы = service['category']['ru']['text']
                        Адрес_подраздела = "http://prom.ua/Uslugi-salonov-krasoty"
                        Возможность_поставки = ""
                        Срок_поставки= ""
                        Способ_упаковки = ""
                        Уникальный_идентификатор = rand(10_000_000-1_000_000)+1_000_000
                        Идентификатор_товара = ""
                        Идентификатор_подраздела = ""
                        Идентификатор_группы = ""
                        Производитель = ""
                        Гарантийный_срок = ""
                        Страна_производитель = ""
                        Скидка = ""
                        aaaaaaaa = ""
                        Название_Характеристики = "Предварительная запись"
                        Измерение_Характеристики  = ""
                        Значение_Характеристики = "да" 
                        csv << [Код_товара,Название_позиции,Ключевые_слова,Описание,Тип_товара,Цена,Валюта,Единица_измерения,Минимальный_объем_заказа,Оптовая_цена,Минимальный_заказ_опт,Ссылка_изображения,Наличие,Количество,Номер_группы,Название_группы,Адрес_подраздела,Возможность_поставки,Срок_поставки,Способ_упаковки,Уникальный_идентификатор,Идентификатор_товара,Идентификатор_подраздела,Идентификатор_группы,Производитель,Гарантийный_срок,Страна_производитель,Скидка,aaaaaaaa,Название_Характеристики,Измерение_Характеристики,Значение_Характеристики]  
                    end
                end
            end
        end
    end


    def promuahtml(rayon, service, serviceid, oblastslug, rayonslug)
            %(
<p><span style=""></span></p>

<h2 style="color: rgb(0, 0, 0); font-family: ArialMT; font-size: 14px;">&nbsp;</h2>

<h2 style="color: rgb(0, 0, 0); font-family: ArialMT; font-size: 14px;">Мы специализируемся в поиске цены от лучших и самых надежных компаний в городе #{rayon}&nbsp;по услуге #{service}.&nbsp;</h2>

<h2 style="color: rgb(0, 0, 0); font-family: ArialMT; font-size: 14px;">&nbsp;</h2>

<ul>
<li>
<h2 style="color: rgb(0, 0, 0); font-family: ArialMT; font-size: 14px;">&nbsp;Через&nbsp;<a href="http://posluga.ua/">Posluga.ua</a>&nbsp;с вами свяжутся предприятия в вашем районе по электронной почте и &nbsp;будут высылать вам свои лучшие цены.</h2>
</li>
</ul>

<p>&nbsp;</p>

<ul>
<li>
<h2 style="color: rgb(0, 0, 0); font-family: ArialMT; font-size: 14px;">&nbsp;Все, что вам нужно сделать, это выбрать наилучшую цену из предложенных от 5 компаний.</h2>
</li>
</ul>

<h2 style="color: rgb(0, 0, 0); font-family: ArialMT; font-size: 14px;">&nbsp;</h2>

<ul>
<li>
<h2 style="color: rgb(0, 0, 0); font-family: ArialMT; font-size: 14px;">&nbsp;Ключевая разница между нами и другими компаниями это то, что наши предприятия свяжутся с Вами и они &ldquo;воюют&rdquo; друг с другом, чтобы дать Вам лучшие цены.</h2>
</li>
</ul>

<h2 style="color: rgb(0, 0, 0); font-family: ArialMT; font-size: 14px;">&nbsp;</h2>

<h2 style="color: rgb(0, 0, 0); font-family: ArialMT; font-size: 14px;">Нажмите ссылку ниже, чтобы рассказать о том, что вы хотите, и мы приступим к поиску лучший цены. Поиск занимает от 2 до 48 часов.</h2>

<p>&nbsp;</p>

<h2><a href="https://posluga.ua/request?type=new&amp;amp;serviceid=#{serviceid}&amp;amp;oblast=#{oblastslug}&amp;amp;rayon=#{rayonslug}" target="_blank">--&gt; Получить 5 цену по услуге #{service} &lt;--</a></h2>

                         <p>&nbsp;</p>
                         )

                         end

                         def placelistpromua
                             [{oblast: "Винницкая область",rayon:"Винница",number:17564869,oblastslug:"vinnickaya-oblast",rayonslug:"vinnica-gorod"},
                                {oblast: "Волынская область",rayon:"Луцк",number:17564882,oblastslug:"volynskaya-oblast",rayonslug:"luck-gorod"},
                                {oblast: "Днепропетровская область",rayon:"Днепр",number:17414196,oblastslug:"dnepropetrovskaya-oblast",rayonslug:"dnepr-gorod"},
                                {oblast: "Днепропетровская область",rayon:"Днепродзержинск",number:17414205,oblastslug:"dnepropetrovskaya-oblast",rayonslug:"dneprodzerzhinsk-gorod"},
                                {oblast: "Днепропетровская область",rayon:"Кривой Рог",number:17414200,oblastslug:"dnepropetrovskaya-oblast",rayonslug:"krivoi-rog-gorod"},
                                {oblast: "Донецкая область",rayon:"Мариуполь",number:17564896,oblastslug:"doneckaya-oblast",rayonslug:"mariupol-gorod"},
                                {oblast: "Житомирская область",rayon:"Житомир",number:17564908,oblastslug:"zhitomirskaya-oblast",rayonslug:"zhitomir-gorod"},
                                {oblast: "Закарпатская область",rayon:"Ужгород",number:17564911,oblastslug:"zakarpatskaya-oblast",rayonslug:"uzhgorod-gorod"},
                                {oblast: "Запорожская область",rayon:"Запорожье",number:17564934,oblastslug:"zaporozhskaya-oblast",rayonslug:"zaporozhe-gorod"},
                                {oblast: "Ивано-Франковская область",rayon:"Ивано-Франковск",number:17564938,oblastslug:"ivano-frankovskaya-oblast",rayonslug:"ivano-frankovsk-gorod"},
                                {oblast: "Киевская область",rayon:"Ирпень",number:17403906,oblastslug:"kievskaya-oblast",rayonslug:"irpen-gorod"},
                                {oblast: "Киевская область",rayon:"Киев",number:17378341,oblastslug:"kievskaya-oblast",rayonslug:"kiev-gorod"},
                                {oblast: "Кировоградская область",rayon:"Кировоград",number:17564945,oblastslug:"kirovogradskaya-oblast",rayonslug:"kirovograd-gorod"},
                                {oblast: "Львовская область",rayon:"Львов",number:17564948,oblastslug:"lvovskaya-oblast",rayonslug:"lvov-gorod"},
                                {oblast: "Львовская область",rayon:"Трускавец",number:17564956,oblastslug:"lvovskaya-oblast",rayonslug:"truskavec-gorod"},
                                {oblast: "Николаевская область",rayon:"Николаев",number:17564965,oblastslug:"nikolaevskaya-oblast",rayonslug:"nikolaev-gorod"},
                                {oblast: "Одесская область",rayon:"Черноморск",number:17564976,oblastslug:"odesskaya-oblast",rayonslug:"chornomorsk-gorod"},
                                {oblast: "Одесская область",rayon:"Одесса",number:17564983,oblastslug:"odesskaya-oblast",rayonslug:"odessa-gorod"},
                                {oblast: "Полтавская область",rayon:"Кременчуг",number:17564785,oblastslug:"poltavskaya-oblast",rayonslug:"kremenchug-gorod"},
                                {oblast: "Полтавская область",rayon:"Полтава",number:17564849,oblastslug:"poltavskaya-oblast",rayonslug:"poltava-gorod"},
                                {oblast: "Ровенская область",rayon:"Ровно",number:17564994,oblastslug:"rovenskaya-oblast",rayonslug:"rovno-gorod"},
                                {oblast: "Сумская область",rayon:"Сумы",number:17565014,oblastslug:"sumskaya-oblast",rayonslug:"sumy-gorod"},
                                {oblast: "Тернопольская область",rayon:"Тернополь",number:17565024,oblastslug:"ternopolskaya-oblast",rayonslug:"ternopol-gorod"},
                                {oblast: "Харьковская область",rayon:"Харьков",number:17565029,oblastslug:"kharkovskaya-oblast",rayonslug:"kharkov-gorod"},
                                {oblast: "Херсонская область",rayon:"Херсон",number:17565067,oblastslug:"khersonskaya-oblast",rayonslug:"kherson-gorod"},
                                {oblast: "Черкасская область",rayon:"Черкассы",number:17565033,oblastslug:"cherkasskaya-oblast",rayonslug:"cherkassy-gorod"},
                                {oblast: "Черниговская область",rayon:"Чернигов",number:17565039,oblastslug:"chernigovskaya-oblast",rayonslug:"chernigov-gorod"},
                                {oblast: "Черновицкая область",rayon:"Черновцы",number:17565087,oblastslug:"chernovickaya-oblast",rayonslug:"chernovcy-gorod"}]
                         end


                         def createsitemap
                             linkArray = []
                             @@dbProviders.each do |provider|
                                 providerlink =  "/provider/" + provider['slug']['latin']['ru']
                                 linkArray.push(providerlink)
                             end
                             @@dbServices.each do |service|
                                 servicelinkLevel1 =  "/top-10/" + service['subcategory']['ru']['slug']
                                 linkArray.push(servicelinkLevel1)
                             end
                             @@dbServices.each do |service|
                                 @@mongoclient[:places].aggregate([{"$group": { "_id": {"oblast": "$oblast"}}}]).each do |place|
                                     oblast = place['_id']['oblast']
                                     @@mongoclient[:providers].find({"oblast.ru": oblast['ru'], "service": service['_id']}).each do |providers|
                                         if providers.length > 0
                                             oblastLink = "/top-10/" + service['subcategory']['ru']['slug'] + '/' + oblast['slug']
                                             if !(linkArray.include? oblastLink )
                                                 linkArray.push(oblastLink);
                                             end
                                             @@mongoclient[:places].aggregate([{  '$match': {  'oblast.slug': oblast['slug']  } }, {'$group':{ "_id": {"rayon": "$rayon"}  }}]).each do |place1|
                                                 rayon = place1['_id']['rayon']
                                                 @@mongoclient[:providers].find({"oblast.ru": oblast['ru'],"rayon.ru": rayon['ru'],"service": service['_id']}).each do |providers1|
                                                     if providers1.length > 0
                                                         if rayon['ru'].include? " город"
                                                             rayonLink = "/top-10/" + service['subcategory']['ru']['slug'] + '/' + oblast['slug']+ '/' + rayon['slug']
                                                             if !(linkArray.include? rayonLink)
                                                                 linkArray.push(rayonLink);
                                                             end
                                                         end
                                                         # @@mongoclient[:places].aggregate([{  '$match': {  'oblast.slug': oblast['slug'], 'rayon.slug': rayon['slug']} }, {'$group':{ "_id": {"gorad": "$gorad"}  }}]).each do |place2|
                                                         #     gorad = place2['_id']['gorad']
                                                         #     if gorad != nil
                                                         #         @@mongoclient[:providers].find({"oblast.ru": oblast['ru'],"rayon.ru": rayon['ru'], "gorad.ru": gorad['ru'], "service": service['_id']}).each do |providers2|
                                                         #             if providers2.length > 0
                                                         #                 goradLink = "/top-10/" + service['subcategory']['ru']['slug'] + '/' + oblast['slug']+ '/' + rayon['slug']+ '/' + gorad['slug']
                                                         #                 linkArray.push(goradLink);
                                                         #                 @@mongoclient[:places].aggregate([{  '$match': {  'oblast.slug': oblast['slug'], 'rayon.slug': rayon['slug'], 'gorad.slug': gorad['slug']} }, {'$group':{ "_id": {"rayongorad": "$rayongorad"}  }}]).each do |place3|
                                                         #                     rayongorad = place3['_id']['rayongorad']
                                                         #                     if rayongorad  != nil
                                                         #                         @@mongoclient[:providers].find({"oblast.ru": oblast['ru'],"rayon.ru": rayon['ru'], "gorad.ru": gorad['ru'], "rayongorad.ru": rayongorad['ru'], "service": service['_id']}).each do |providers3|
                                                         #                             if providers3.length > 0
                                                         #                                 rayongoradLink = "/top-10/" + service['subcategory']['ru']['slug'] + '/' + oblast['slug']+ '/' + rayon['slug']+ '/' + gorad['slug']+ '/' + rayongorad['slug']
                                                         #                                 linkArray.push(rayongoradLink);
                                                         #                             end
                                                         #                         end
                                                         #                     end
                                                         #                 end
                                                         #             end
                                                         #         end
                                                         #     end
                                                         # end
                                                     end
                                                 end
                                             end
                                         end
                                     end
                                 end
                             end
                             bigArray = linkArray.each_slice(40000).to_a
                             indexmap = XmlSitemap::Index.new(:secure => true)
                             bigArray.each_with_index do |array, index|
                                 map = XmlSitemap::Map.new('posluga.ua', :secure => true) do |m|
                                     array.each do |link|
                                         m.add link, :updated => Date.today, :period => :daily
                                     end
                                 end
                                 map.render_to("sitemap-#{(index+1).to_s}.xml")
                                 indexmap.add(map)
                             end
                             indexmap.render_to('sitemapindex.xml')
                         end

                         def updateplaces
                             @@dbPlaces.each do |place|
                                 oblast = place['oblast']
                                 rayon = place['rayon']
                                 place['oblast']['ruinform'] = converttoinform(oblast['ru'])
                                 place['oblast']['ukinform'] = converttoinform(oblast['uk'])
                                 place['rayon']['ruinform'] = converttoinform(rayon['ru'])
                                 place['rayon']['ukinform'] = converttoinform(rayon['uk'])
                                 @@mongoclient[:places].update_one({"_id" => place['_id']}, place)
                                 puts "updated:" + ' ' + place['_id'].to_s
                             end
                         end

                         def converttoinform(word)
                             result = nil
                             if(word.include? "кая область")
                                 x = word.chomp "кая область"
                                 result = "в #{x}кой области"
                             elsif (word.include? "ька область")
                                 x = word.chomp "ька область"
                                 result = "у #{x}ькій області"
                             elsif(word.include? "ский район")
                                 x = word.chomp "ский район"
                                 result = "в #{x}ском районе"
                             elsif (word.include? "ський район")
                                 x = word.chomp "ський район"
                                 result = "у #{x}ському районі"
                             elsif (word.include? "Кривой Рог город")
                                 result = "в Кривом Роге"
                             elsif (word.include? "Нова Каховка город")
                                 result = "в Новой Каховке"
                             elsif (word.include? "Ровеньки город")
                                 result = "в Ровеньках"
                             elsif (word.include? "Желтые Воды город")
                                 result = "в Желтых Водах"
                             elsif (word.include? "Красный Луч город")
                                 result = "в Красном Луче"
                             elsif (word.include? "Горишние Плавни город")
                                 result = "в Горишних Плавнях"
                             elsif (word.include? "Чоп город")
                                 result = "в Чоп"
                             elsif (word.include? "Вараш город")
                                 result = "в Вараше"
                             elsif (word.include? "Хмельницкий город")
                                 result = " в Хмельницком"
                             elsif (word.include? "ск город")
                                 x = word.chomp "ск город"
                                 result = "в #{x}ске"
                             elsif (word.include? "цк город")
                                 x = word.chomp "цк город"
                                 result = "в #{x}цке"
                             elsif (word.include? "р город")
                                 x = word.chomp "р город"
                                 result = "в #{x}ре"
                             elsif (word.include? "е город")
                                 x = word.chomp "е город"
                                 result = "в #{x}е"
                             elsif (word.include? "о город")
                                 x = word.chomp "о город"
                                 result = "в #{x}о"
                             elsif ((word.include? "а город") && !(word.include? "Нова Каховка город"))
                                 x = word.chomp "а город"
                                 result = "в #{x}е"
                             elsif (word.include? "ное город")
                                 x = word.chomp "ное город"
                                 result = "в #{x}ном"
                             elsif (word.include? "кий город")
                                 x = word.chomp "кий город"
                                 result = "в #{x}ком"
                             elsif (word.include? "ь город")
                                 x = word.chomp "ь город"
                                 result = "в #{x}е"
                             elsif (word.include? "д город")
                                 x = word.chomp "д город"
                                 result = "в #{x}де"
                             elsif (word.include? "в город")
                                 x = word.chomp "в город"
                                 result = "в #{x}ве"
                             elsif (word.include? "ц город")
                                 x = word.chomp "ц город"
                                 result = "в #{x}це"
                             elsif (word.include? "Черноморск")
                                 result = "в Черноморске"
                             elsif (word.include? "г город")
                                 x = word.chomp "г город"
                                 result = "в #{x}ге"
                             elsif (word.include? "н город")
                                 x = word.chomp "н город"
                                 result = "в #{x}не"
                             elsif (word.include? "ц город")
                                 x = word.chomp "ц город"
                                 result = "в #{x}це"
                             elsif ((word.include? "ы город") && !(word.include? "Желтые Воды город"))
                                 x = word.chomp "ы город"
                                 result = "в #{x}ах"
                             elsif (word.include? "Івано-Франківськ місто")
                                 result = "в Івано-Франківську"
                             elsif (word.include? "Яремча місто")
                                 result = "в Яремче"
                             elsif (word.include? "Луцьк місто")
                                 result = "у Луцьку"
                             elsif (word.include? "Нововолинськ місто")
                                 result = "у Нововолинську"
                             elsif (word.include? "Вінниця місто")
                                 result = "у Вінниці"
                             elsif (word.include? "Вільногірськ місто")
                                 result = "у Вільногірську"
                             elsif (word.include? "Дніпро місто")
                                 result = "у Дніпрі"
                             elsif (word.include? "Жовті води місто")
                                 result = "у Жовтих Водах"
                             elsif (word.include? "Дніпродзержинськ місто")
                                 result = "у Дніпродзержинськ"
                             elsif (word.include? "Тернівка місто")
                                 result = "у Тернівці"
                             elsif (word.include? "Єнакієве місто")
                                 result = "в Єнакієвому"
                             elsif (word.include? "Горлівка місто")
                                 result = "у Горлівці"
                             elsif (word.include? "Першотравенськ місто")
                                 result = "у Першотравенську"
                             elsif (word.include? "Покров місто")
                                 result = "у Покрові"
                             elsif (word.include? "Марганець місто")
                                 result = "у Марганці"
                             elsif (word.include? "Кривий ріг місто")
                                 result = "у Кривому Розі"
                             elsif (word.include? "Дебальцеве місто")
                                 result = "у Дебальцевому"
                             elsif (word.include? "Донецьк місто")
                                 result = "у Донецьку"
                             elsif (word.include? "Дружківка місто")
                                 result = "у Дружківці"
                             elsif (word.include? "Краматорськ місто")
                                 result = "у Краматорську"
                             elsif (word.include? "Дзержинськ місто")
                                 result = "у Дзержинськ"
                             elsif (word.include? "Макіївка місто")
                                 result = "у Макіївці"
                             elsif (word.include? "Маріуполь місто")
                                 result = "у Маріуполі"
                             elsif (word.include? "Селидове місто")
                                 result = "у Селидовому"
                             elsif (word.include? "Сніжне місто")
                                 result = "у Сніжному"
                             elsif (word.include? "Торез місто")
                                 result = "у Торез"
                             elsif (word.include? "Харцизьк місто")
                                 result = "у Харцизьку"
                             elsif (word.include? "Луцьк місто")
                                 result = "у Луцьку"
                             elsif (word.include? "Житомир місто")
                                 result = "у Житомирі"
                             elsif (word.include? "Ужгород місто")
                                 result = "в Ужгороді"
                             elsif (word.include? "Чоп місто")
                                 result = "у Чопі"
                             elsif (word.include? "Енергодар місто")
                                 result = "в Енергодарі"
                             elsif (word.include? "Запоріжжя місто")
                                 result = "у Запоріжжі"
                             elsif (word.include? "Ірпінь місто")
                                 result = "в Ірпені"
                             elsif (word.include? "Київ місто")
                                 result = "у Києві"
                             elsif (word.include? "Славутич місто")
                                 result = "у Славутичі"
                             elsif (word.include? "Кіровоград місто")
                                 result = "у Кропивницькому"
                             elsif (word.include? "Алчевськ місто")
                                 result = "в Алчевську"
                             elsif (word.include? "Брянка місто")
                                 result = "у Брянці"
                             elsif (word.include? "Красний Луч місто")
                                 result = "в Красний Луч"
                             elsif (word.include? "Кіровськ місто")
                                 result = "у Кіровську"
                             elsif (word.include? "Лисичанськ місто")
                                 result = "у Лисичанську"
                             elsif (word.include? "Луганськ місто")
                                 result = "у Луганську"
                             elsif (word.include? "Первомайськ місто")
                                 result = "у Первомайську"
                             elsif (word.include? "Ровеньки місто")
                                 result = "у Ровеньках"
                             elsif (word.include? "Рубіжне місто")
                                 result = "у Рубіжному"
                             elsif (word.include? "Стаханов місто")
                                 result = "у Стаханові"
                             elsif (word.include? "Сіверськодонецьк місто")
                                 result = "у Сіверськодонецьку"
                             elsif (word.include? "Трускавець місто")
                                 result = "у Трускавці"
                             elsif (word.include? "Червоноград місто")
                                 result = "у Червонограді"
                             elsif (word.include? "Борислав місто")
                                 result = "у Бориславі"
                             elsif (word.include? "Львів місто")
                                 result = "у Львові"
                             elsif (word.include? "Миколаїв місто")
                                 result = "у Миколаєві"
                             elsif (word.include? "Южноукраїнськ місто")
                                 result = "у Южноукраїнську"
                             elsif (word.include? "Чорноморськ місто")
                                 result = "в Чорноморську"
                             elsif (word.include? "Одеса місто")
                                 result = "в Одесі"
                             elsif (word.include? "Горішні Плавні місто")
                                 result = "у Горішніх Плавнях"
                             elsif (word.include? "Кременчук місто")
                                 result = "у Кременчуці"
                             elsif (word.include? "Полтава місто")
                                 result = "у Полтаві"
                             elsif (word.include? "Вараш місто")
                                 result = "у Вараші"
                             elsif (word.include? "Рівне місто")
                                 result = "в Рівному"
                             elsif (word.include? "Суми місто")
                                 result = "у Сумах"
                             elsif (word.include? "Тернопіль місто")
                                 result = "у Тернополі"
                             elsif (word.include? "Харків місто")
                                 result = "у Харкові"
                             elsif (word.include? "Нова Каховка місто")
                                 result = "у Новій Каховці"
                             elsif (word.include? "Херсон місто")
                                 result = "у Херсоні"
                             elsif (word.include? "Нетішин місто")
                                 result = "у Нетішині"
                             elsif (word.include? "Хмельницький місто")
                                 result = "у Хмельницькому"
                             elsif (word.include? "Черкаси місто")
                                 result = "у Черкасах"
                             elsif (word.include? "Чернівці місто")
                                 result = "у Чернівцях"
                             elsif (word.include? "Чернігів місто")
                                 result = "у Черкасах"
                             elsif (word.include? "Черкаси місто")
                                 result = "у Чернігові"
                             elsif (word.include? "Хрестівка місто")
                                 result = "у Хрестівці"
                             end
                             return result
                         end
                         end
                         Crawler.new()
