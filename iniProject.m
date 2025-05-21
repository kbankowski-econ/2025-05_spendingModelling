function iniProject()
    
    % the initiation file has to remain in the main home directory of the
    % project; this is becuase it calls credential and paths functions,
    % which are specified as packages and they have to be visible to the
    % current session (ideally) without adding paths
    
    % restoring default paths just in case project has to be re-initiated
    restoredefaultpath;

    % cleaning evenrything
    close all;
    clear all;
    clc;

    % reading in local variables
    % utils.call.credential;
    utils.call.paths;

    % system path to some packages needed for mermaid
%     setenv('PATH', matlabEnv_path);
%     setenv('PATH', [getenv('PATH') [':', node_path]])
    % this command displays the environment paths
    % disp(getenv('PATH'))
    
    % adding paths
    % project
    addpath(genpath(project_path));
    % Matlab utils
    addpath(matlabUtils_path);
    % iris
    addpath(iris_path);

    % initiating toolboxes
    % iris
    iris.startup();

    % Call Dynare
    addpath(dynare_6_1_official);
    dynare_config()

end