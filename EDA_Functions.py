import numpy as np

def owns_home(house_type):
    '''Takes in house_type_30 code and exports a boolean, 1 for owned home, regardless of type and 0 for rental home'''
    if house_type == 6: # renting
        return 0
    else:
        return 1

def owns_perm_home(house_type):
    '''Takes in house_type_30 code and exports a boolean, 1 for owned home, regardless of type and 0 for rental home'''
    if house_type == 6: #renting
        return 0
    elif house_type == 2: #ranch/farm
        return 0
    elif house_type == 3: #mobile home
        return 0
    else:
        return 1

def income_est_decoder(est, median_25k):
    '''
    Takes in a coded wage value and decodes it into a continuous variable: the median of the interval set by the study's code key. 
    Also takes in the median of the salaries above 25k from the income_[]_total columns. 
    '''
    if est <= 0:
        return 0
    elif est == 1:
        return np.median([0, 5000])
    elif est == 2:
        return np.median([5000, 10000])
    elif est == 3:
        return np.median([10000, 25000])
    elif est == 4:
        return np.median([25000, 50000]) 
    elif est == 5:
        return np.median([50000, 100000]) 
    elif est == 6:
        return np.median([100000, 250000])
    elif est == 7:
        if median_25k > 250000:
            return median_25k
        else:
            return 250000

def income_bus_transformer(code):
    '''Takes in an encoded business/farm income integer value which represents an income interval and standardizes it to the same encoding as the wage income encoding '''
    if code > 0:
        code = code -1
        return code

def income_compiler(total, est):
    """
    Compiles our total and estimate columns:
    Takes continuous variable from total income and estimate income columns and returns the income that is not null and/or not 0 from either column.
    """

    if np.isnan(total) == True:
        if np.isnan(est) == False:
            return est
    elif total == 0:
        if np.isnan(est) == False and est > 0:
            return est
        else:
            return total
    else:
        return total

def married(marital_status):
    """
    Takes in marial status code from study's key and returns 1 for married and 0 for all other statuses.
    """
    if marital_status == 3 : #3='Married, spouse present'
        return 1
    elif marital_status == 4: #4='Married, spouse absent'
        return 1
    else:
        return 0

def cohabitating(marital_status):
    """
    Takes in cohabitation status code from study's key and returns 1 for cohabitating (regardless of legal relationship status) and 0 for not cohabitating.
    """
    if marital_status == 1 : #1='Never married, cohabiting'
        return 1
    elif marital_status == 3: #3='Married, spouse present'
        return 1
    elif marital_status == 5: #5='Separated, cohabiting'
        return 1
    elif marital_status == 7: #7='Divorced, cohabiting'
        return 1
    elif marital_status == 9: #9='Widowed, cohabiting'
        return 1
    else:
        return 0

def metro(metro_area):
    """
    Takes in cohabitation status code from study's key and returns 1 for CBSA (metro area) and 0 for all else.
    """
    if metro_area == 2: # 2='In CBSA, not in central city'
        return 1
    elif metro_area == 3: #3='In CBSA, in central city'
        return 1
    elif metro_area == 4: #4='In CBSA, not known'
        return 1
    else: 
        return 0

def central_city(metro_area):
    """
    Takes in cohabitation status code from study's key and returns 1 for in CBSA and in central city and 0 for all else.
    """
    if metro_area == 3: #3='In CBSA, in central city'
        return 1
    else: 
        return 0

def childhood_owned(childhood_home):
    """
    Takes in childhood home ownership key and returns 1 for owned home and 0 for all else.
    """
    if childhood_home == 1: #1='OWNS OR IS BUYING; LAND CONTRACT'
        return 1
    else: 
        return 0

def interview_skips(column):
    Valid_skip = 0
    Invalid_skip = 0
    Dont_know = 0
    Refusal = 0
    for key in column:

        if key == -4:
            Valid_skip+=1
        if key == -3:
            Invalid_skip+=1
        if key == -2:
            Dont_know+=1
        if key == -1:
            Refusal+=1

    print("Valid_skips : {}".format(Valid_skip))
    print("Invalid_skips : {}".format(Invalid_skip))
    print("Don't Know : {}".format(Dont_know))
    print("Refusal : {}".format(Refusal))

def adult_child_pov_ratio(pov, child_pov):
    if pov > 0 and child_pov > 0: #to avoid 0 poverty ratio and skips(indicated by negative integers)
        return pov/child_pov

def bus_or_farm_income(bus):
    if bus > 0:
        return 1
    else: 
        return 0
