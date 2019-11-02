
// DO NOT EDIT THIS BLOCK === promote_autogen starts ===
import groovy.transform.BaseScript
import com.electriccloud.commander.dsl.util.BasePlugin

//noinspection GroovyUnusedAssignment
@BaseScript BasePlugin baseScript

// Variables available for use in DSL code
def pluginName = args.pluginName
def upgradeAction = args.upgradeAction
def otherPluginName = args.otherPluginName

def pluginKey = getProject("/plugins/$pluginName/project").pluginKey
def pluginDir = getProperty("/projects/$pluginName/pluginDir").value

//List of procedure steps to which the plugin configuration credentials need to be attached
def stepsWithAttachedCredentials = [
    [procedureName: "CollectReportingData", stepName: "CollectReportingData"],

]

project pluginName, {
    property 'ec_keepFilesExtensions', value: 'true'
    property 'ec_formXmlCompliant', value: 'true'
    loadPluginProperties(pluginDir, pluginName)
    loadProcedures(pluginDir, pluginKey, pluginName, stepsWithAttachedCredentials)

    // Plugin configuration metadata
    property 'ec_config', {
        configLocation = 'ec_plugin_cfgs'
        form = '$[' + "/projects/$pluginName/procedures/CreateConfiguration/ec_parameterForm]"
        property 'fields', {
            property 'desc', {
                property 'label', value: 'Description'
                property 'order', value: '1'
            }
        }
    }

    // Feature: devOpsInsight
    property 'ec_devops_insight', {

    property 'build', {
        property 'source', value: 'Sample Reporting Source'
        property 'operations', {
            property 'createDOISDataSource', {
                property 'procedureName', value: 'ValidateCRDParams'
            }
            property 'modifyDOISDataSource', {
                property 'procedureName', value: 'ValidateCRDParams'
            }
        }
    }
}
    }

upgrade(upgradeAction, pluginName, otherPluginName, stepsWithAttachedCredentials)
// DO NOT EDIT THIS BLOCK === promote_autogen ends, checksum: db68801fc56a261875de1507e71392fc ===
// Do not edit the code above this line

project pluginName, {
    // You may add your own DSL instructions below this line, like
    // property 'myprop', {
    //     value: 'value'
    // }
}