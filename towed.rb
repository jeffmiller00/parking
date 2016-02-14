require 'sinatra'
require 'soda/client'
require 'tilt/erubis'


get '/' do
  raw_response = fetch_data unless @results
  @results ||= count_and_format raw_response
  erb :word_cloud
end


private


def fetch_data
  client = SODA::Client.new({domain: 'data.cityofchicago.org', app_token: 'WbQrPgfvEqxSt0v2wRdkBJ82s'})
  response = client.get('ygr5-vcbg')
end

def count_and_format response = fetch_data
  make_map = {
    'CHEV'=>'Chevy',
    'ACUR'=>'Acura',
    'FORD'=>'Ford',
    'DODG'=>'Dodge',
    'CADI'=>'Cadillac',
    'BUIC'=>'Buick',
    'TOYT'=>'Toyota',
    'AUDI'=>'Audi',
    'CHRY'=>'Chrysler',
    'HOND'=>'Honda',
    'HYUN'=>'Hyundai',
    'INFI'=>'Infinity',
    'LEXS'=>'Lexus',
    'LINC'=>'Lincoln',
    'MAZD'=>'Mazda',
    'MERC'=>'Mercury',
    'MITS'=>'Mitsubishi',
    'NISS'=>'Nissan',
    'PONT'=>'Pontiac',
    'PORS'=>'Porche',
    'SAA' =>'Saab',
    'SUZI'=>'Suzizuki',
    'VOLK'=>'Volkswagen',
    'VOLV'=>'Volvo',
    'LAND'=>'Land Rover',
    'OLDS'=>'Oldsmobile',
    'PLYM'=>'Plymouth',
    'SATR'=>'Saturn',
    'SCIO'=>'Scion',
    'SUBA'=>'Subauru',
    'LEXU'=>'Lexus'}.freeze
  h = Hash.new 0
  response.collect{|c| c.make}.each{|m| h.store(m,h[m]+1)}
  h.map{|k,v| {text: make_map[k] || k || 'Unknown', weight: v}}.to_json
end