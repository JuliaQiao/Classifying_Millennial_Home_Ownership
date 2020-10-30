import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split, StratifiedKFold
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from imblearn.over_sampling import RandomOverSampler, SMOTE, ADASYN
from sklearn.metrics import plot_confusion_matrix, plot_roc_curve, classification_report, roc_curve, recall_score, precision_score, roc_auc_score

from collections import Counter 


def get_score(X_train_val, y_train_val, model):
    
    """
    Scores model fit based on X_train_val and y_train_val (obtained after train_val and test split) and model selection.
    inputs= Dataframe X, y, and SKlearn model.
    output= model score for training and validation sets based on stratefied k-fold with 5 splits. 
    """ 
    #use stratified kfold to splice up on train-val into train and val
    skfold = StratifiedKFold(n_splits=5, shuffle = True, random_state=7)
    skfold.get_n_splits(X_train_val, y_train_val)
    
    #create a list to store our scores
    train_scores= []
    val_scores= []
    precision_scores= []
    recall_scores= []
    auc_scores = []
    
    #fit and score model on each fold
    for train, val in skfold.split(X_train_val, y_train_val):
        #set up train and val for each fold
        X_train, X_val = X_train_val.iloc[train], X_train_val.iloc[val]
        y_train, y_val = y_train_val.iloc[train], y_train_val.iloc[val]
        #fit model
        model.fit(X_train, y_train)
        #make prediction using y-val
        y_pred =  model.predict(X_val)
        #append scores onto list
        train_scores.append(model.score(X_train, y_train))
        val_scores.append(model.score(X_val, y_val)) 
        auc_scores.append(roc_auc_score(y_val, y_pred))
        precision_scores.append(precision_score(y_val, y_pred))
        recall_scores.append(recall_score(y_val, y_pred))
        
    #find the means for our scores
    mean_train = np.mean(train_scores)
    mean_val = np.mean(val_scores)
    auc_score = np.mean(auc_scores)
    precision = np.mean(precision_scores)
    recall = np.mean(recall_scores)
    
    #print our mean accuracy score, our train/test ratio precision, and recall
    print(f'Accuracy: {mean_val:.4f}')
    print(f'Train/Test ratio: {(mean_train)/(mean_val):.4f}')
    
    print(f'AUC: {auc_score:.4f}')
    print(f'Precision: {precision:.4f}')
    print(f'RECALL: {recall:.4f}')


def get_score_scaled (X_train_val, y_train_val, model):
    
    """
    Scores model fit based on X_train_val and y_train_val (obtained after train_val and test split) and model selection.
    inputs= Dataframe X, y, and SKlearn model.
    output= model score for training and validation sets based on stratefied k-fold with 5 splits. 
    """
    #use stratified kfold to splice up on train-val into train and val
    skfold = StratifiedKFold(n_splits=5, shuffle = True, random_state=7)
    skfold.get_n_splits(X_train_val, y_train_val)
    
    #create a list to store our scores
    train_scores= []
    val_scores= []
    precision_scores= []
    recall_scores= []
    auc_scores = []
    
    #fit and score model on each fold
    for train, val in skfold.split(X_train_val, y_train_val):
        #set up train and val for each fold
        X_train, X_val = X_train_val.iloc[train], X_train_val.iloc[val]
        y_train, y_val = y_train_val.iloc[train], y_train_val.iloc[val]
        #Scale data
        ss = StandardScaler()
        #fit transform X train
        X_train_scaled = ss.fit_transform(X_train)
        #transform X val
        X_val_scaled = ss.transform(X_val)
        #fit model
        model.fit(X_train_scaled, y_train)
        #make prediction using y-val
        y_pred =  model.predict(X_val_scaled)
        #append scores onto list
        train_scores.append(model.score(X_train_scaled, y_train))
        val_scores.append(model.score(X_val_scaled, y_val))
        auc_scores.append(roc_auc_score(y_val, y_pred))
        precision_scores.append(precision_score(y_val, y_pred))
        recall_scores.append(recall_score(y_val, y_pred))
        
    #find the means for our scores
    mean_train = np.mean(train_scores)
    mean_val = np.mean(val_scores)
    auc_score = np.mean(auc_scores)
    precision = np.mean(precision_scores)
    recall = np.mean(recall_scores)
    
    #print our mean accuracy score, our train/test ratio precision, and recall
    print(f'Accuracy: {mean_val:.4f}')
    print(f'Train/Test ratio: {(mean_train)/(mean_val):.4f}')
    
    print(f'AUC: {auc_score:.4f}')
    print(f'Precision: {precision:.4f}')
    print(f'RECALL: {recall:.4f}')

def get_score_oversampled (X_train_val, y_train_val, model, oversampler):
    """
    Scores model fit based on X_train_val and y_train_val (obtained after train_val and test split) and model selection.
    Uses oversampling to balance classes.
    inputs= Dataframe X, y, and SKlearn model.
    output= model score for training and validation sets based on stratefied k-fold with 5 splits. 
    """
    #use stratified kfold to splice up on train-val into train and val
    skfold = StratifiedKFold(n_splits=5, shuffle = True, random_state=7)
    skfold.get_n_splits(X_train_val, y_train_val)
    #create a list to store our scores
    train_scores= []
    val_scores= []
    precision_scores= []
    recall_scores= []
    auc_scores = []
    #fit and score model on each fold
    for train, val in skfold.split(X_train_val, y_train_val):
        #set up train and val for each fold
        X_train, X_val = X_train_val.iloc[train], X_train_val.iloc[val]
        y_train, y_val = y_train_val.iloc[train], y_train_val.iloc[val]
        #oversample train data
        X_train_oversampled,y_train_oversampled = oversampler.fit_sample(X_train,y_train)
        #fit model
        model.fit(X_train_oversampled, y_train_oversampled)
        #make prediction using y-val
        y_pred =  model.predict(X_val)
        #append scores onto list
        train_scores.append(model.score(X_train_oversampled, y_train_oversampled))
        val_scores.append(model.score(X_val, y_val))
        auc_scores.append(roc_auc_score(y_val, y_pred))
        precision_scores.append(precision_score(y_val, y_pred))
        recall_scores.append(recall_score(y_val, y_pred))
    #find the means for our scores
    mean_train = np.mean(train_scores)
    mean_val = np.mean(val_scores)
    auc_score = np.mean(auc_scores)
    precision = np.mean(precision_scores)
    recall = np.mean(recall_scores)
    #print our mean accuracy score, our train/test ratio precision, and recall
    print(f'Accuracy: {mean_val:.4f}')
    print(f'Train/Test ratio: {(mean_train)/(mean_val):.4f}')

    print(f'AUC: {auc_score:.4f}')
    print(f'Precision: {precision:.4f}')
    print(f'RECALL: {recall:.4f}')

def get_score_scaled_oversampled (X_train_val, y_train_val, model, oversampler):
    """
    Scores model fit based on X_train_val and y_train_val (obtained after train_val and test split) and model selection.
    Scales data
    Uses oversampling to balance classes.
    inputs= Dataframe X, y, and SKlearn model.
    output= model score for training and validation sets based on stratefied k-fold with 5 splits. 
    """
    #use stratified kfold to splice up on train-val into train and val
    skfold = StratifiedKFold(n_splits=5, shuffle = True, random_state=7)
    skfold.get_n_splits(X_train_val, y_train_val)
    #create a list to store our scores
    train_scores= []
    val_scores= []
    precision_scores= []
    recall_scores= []
    auc_scores = []
    #fit and score model on each fold
    for train, val in skfold.split(X_train_val, y_train_val):
        #set up train and val for each fold
        X_train, X_val = X_train_val.iloc[train], X_train_val.iloc[val]
        y_train, y_val = y_train_val.iloc[train], y_train_val.iloc[val]
        #Scale data
        ss = StandardScaler()
        #fit transform X train
        X_train_scaled = ss.fit_transform(X_train)
        #transform X val
        X_val_scaled = ss.transform(X_val)
        #oversample train data
        X_train_oversampled,y_train_oversampled = oversampler.fit_sample(X_train_scaled,y_train)
        #fit model
        model.fit(X_train_oversampled, y_train_oversampled)
        #make prediction using y-val
        y_pred =  model.predict(X_val_scaled)
        #append scores onto list
        train_scores.append(model.score(X_train_oversampled, y_train_oversampled))
        val_scores.append(model.score(X_val_scaled, y_val))
        auc_scores.append(roc_auc_score(y_val, y_pred))
        precision_scores.append(precision_score(y_val, y_pred))
        recall_scores.append(recall_score(y_val, y_pred))
    #find the means for our scores
    mean_train = np.mean(train_scores)
    mean_val = np.mean(val_scores)
    auc_score = np.mean(auc_scores)
    precision = np.mean(precision_scores)
    recall = np.mean(recall_scores)
    #print our mean accuracy score, our train/test ratio precision, and recall
    print(f'Accuracy: {mean_val:.4f}')
    print(f'Train/Test ratio: {(mean_train)/(mean_val):.4f}')

    print(f'AUC: {auc_score:.4f}')
    print(f'Precision: {precision:.4f}')
    print(f'RECALL: {recall:.4f}')

def get_coef(X_train_val, y_train_val, model):
    """
    Fits logistic model fit based on X_train_val and y_train_val (obtained after train_val and test split).
    Returns coefficients for logistic regression
    inputs= Dataframe X, y, and SKlearn model.
    output= coefficients for logistic regression. 
    """
    #use stratified kfold to splice up on train-val into train and val
    skfold = StratifiedKFold(n_splits=5, shuffle = True, random_state=7)
    skfold.get_n_splits(X_train_val, y_train_val)

    #fit and score model on each fold
    for train, val in skfold.split(X_train_val, y_train_val):
        #set up train and val for each fold
        X_train, X_val = X_train_val.iloc[train], X_train_val.iloc[val]
        y_train, y_val = y_train_val.iloc[train], y_train_val.iloc[val]
        #Scale data
        ss = StandardScaler()
        #fit transform X train
        X_train_scaled = ss.fit_transform(X_train)
        #transform X val
        X_val_scaled = ss.transform(X_val)
        #fit model
        model.fit(X_train_scaled, y_train)
        #make prediction using y-val
        y_pred =  model.predict(X_val_scaled)
        #turns coeficients into absolute values and turns the array into list

    coef = (model.coef_.tolist()[0])
    #zips features and coeficients into list for easier reading
    features = list(zip(list(X_train.columns), coef))
    features.sort(reverse=True, key=lambda x: abs(x[-1]))
    return features