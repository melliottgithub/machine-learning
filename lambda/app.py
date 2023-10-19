
import json
import joblib

MODEL_NAME = 'svm_pipeline' # enter model name

def load_model(model_name):
    file_name = f'./models/{model_name}.pkl'
    saved_model = joblib.load(file_name)
    return saved_model

def pre_process_input(params, model):
    # feature_names = model['feature_names']
    # encoders = model['encoders']
    # X_input = []
    # for name in feature_names:
    #     x = params.get(name)
        
    #     encoder = encoders.get(name)
    #     if encoder is not None:
    #         x = encoder.transform([x])[0]
        
    #     X_input.append(x)
    return [params['text']]

def post_process_output(y_pred, model):
    return y_pred

def lambda_handler(event, context):
    params = event.get('body')
    print(event)
    
    try:
        if type(params) == str:
            params = json.loads(event.get('body'))
            
        model = load_model(MODEL_NAME)
        #model = saved_model['model']
        
        X_input = pre_process_input(params, model)
        
        y_pred = model.predict(X_input).tolist()
        
        output = post_process_output(y_pred, model)

        response = {'output': output}
        return {
            'statusCode': 200,
            'body': json.dumps(response)
        }
    except MemoryError:
        return {
            'statusCode': 500,
            'body': 'MemoryError'
        }
    except Exception as ex:
        return {
            'statusCode': 500,
            'body': f'Internal error: {str(ex)}'
        }