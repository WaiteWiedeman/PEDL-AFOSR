classdef myRegressionLayer < nnet.layer.RegressionLayer ...
        & nnet.layer.Acceleratable
    % Example custom regression layer with mean-absolute-error loss.
    
    methods
        function layer = myRegressionLayer(name)
            % layer = myRegressionLayer(name) creates a
            % mean-sqaure-error regression layer and specifies the layer
            % name.
            % Set layer name.
            layer.Name = name;
            % Set layer description.
            layer.Description = 'Mean Square Error';
        end
        
        function loss = forwardLoss(layer, Y, T)
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            % data loss: compute the difference between target and predicted values
            dataLoss = mean((T-Y).^2,'all');
            % loss = dataLoss;

            % physics loss
            YF = physics_law(Y);
            TF = physics_law(T);
            physicLoss = mean((TF-YF).^2,'all');
            % final loss, combining data loss and physics loss
            alpha = 0.5;
            loss = (1.0-alpha)*dataLoss + alpha*physicLoss;
            %loss = physicLoss;
        end

        function dLdY = backwardLoss(layer,Y,T)
            % (Optional) Backward propagate the derivative of the loss 
            % function.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         dLdY  - Derivative of the loss with respect to the 
            %                 predictions Y        

            dLdY = 2 * (Y - T) / numel(T);
        end
    end
end