import os
import numpy as np
import pandas as pd

import matplotlib.pyplot as plt

path_data = '/Users/mm28969/Projects/DataFest/datafest/2019/data/'

def get_data_file_path(file_name, is_absolute=True):

    path_file = None

    if is_absolute:
        path_file = path_data + file_name
    else:
        path_dir = os.path.dirname(__file__)
        path_file = os.path.join(path_dir, '../../../data/{}'.format(file_name))

    return path_file

def load_n_process():

    path_data_file = get_data_file_path("city_attributes.csv")
    df_cities = pd.read_csv(path_data_file)

    path_data_file = get_data_file_path("temperature.csv")
    df_temperature = pd.read_csv(path_data_file)
    df_temperature['year'] = df_temperature.datetime.str[0:4]
    df_temperature['year_month'] = df_temperature.datetime.str[0:7]
    df_temperature['date'] = df_temperature.datetime.str[0:10]

    df_temperature_long = df_temperature.melt(id_vars=['datetime', 'year', 'year_month', 'date'])
    df_temperature_long.rename(columns={"variable": "City", "value": "temperature"}, inplace=True)
    df_temperature_long.temperature = pd.to_numeric(df_temperature_long.temperature)

    df_city_temp = df_cities.merge(df_temperature_long, on='City')

    return df_city_temp

def make_interp_generator(domain, range):
    return lambda v: np.interp(v,domain, range)

def make_plots():

    df_city_temp = load_n_process()


    df_city_temp_agg = df_city_temp.groupby(['year', 'City', 'Latitude', 'Longitude']).temperature.agg(
        ['min', 'max', 'mean', 'median'])
    df_city_temp_agg.rename(
        columns={"min": "min_temperature", "max": "max_temperature", "median": "median_temperature",
                 "mean": "mean_temperature"}, inplace=True)
    df_city_temp_agg.reset_index(inplace=True)

    domain = [df_city_temp_agg.mean_temperature.min(), df_city_temp_agg.mean_temperature.max()]
    range = [1, 100]
    interpreter = make_interp_generator(domain, range)
    df_city_temp_agg['temp_size'] = df_city_temp_agg.mean_temperature.apply(interpreter)

    # scatter plot by Long/Lat
    b_is_year = df_city_temp_agg.year == '2012'
    df_city_temp_agg_year = df_city_temp_agg[b_is_year]

    fig = plt.figure()

    plt.scatter(df_city_temp_agg_year.Longitude, df_city_temp_agg_year.Latitude, s=df_city_temp_agg_year.temp_size,
                alpha=0.8)

    plt.show()



    df_country_temp_agg = df_city_temp.groupby(['year', 'Country']).temperature.agg(['min', 'max', 'median', 'mean'])
    df_country_temp_agg.rename(columns={"min": "min_temperature", "max": "max_temperature", "median": "median_temperature", "mean": "mean_temperature"}, inplace=True)
    df_country_temp_agg.reset_index(inplace=True)

    fig = plt.figure()
    palette_iter = iter(['#1b9e77', '#d95f02', '#7570b3'])


    # Country temperature over time
    countries = df_country_temp_agg.Country.unique()
    for country in countries:
        b_is_country = df_country_temp_agg.Country == country
        df_country = df_country_temp_agg[b_is_country]
        color = c=next(palette_iter)
        # plt.fill_between(df_country.year, df_country.max_temperature, df_country.min_temperature, color=color, alpha=0.3)
        plt.plot(df_country.year, df_country.mean_temperature, '-', c=color, label=country, alpha=1.0)

    plt.xlabel('Time')
    plt.ylabel('Temperature')

    plt.legend(ncol=3)

    plt.show()



if __name__ == "__main__":
    make_plots()