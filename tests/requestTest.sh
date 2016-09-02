#!/usr/bin/env bash
set -o errexit -o pipefail -o errtrace
source ../vendor/bash-packages/testing.sh
source ../core/request.sh

# Default entries
declare -r TEST_QUERY_API_ID="123-456-7890"
declare -r TEST_QUERY_API_VERSION="v201605"
declare -r TEST_QUERY_BAD_API_VERSION="v0883"
declare -r TEST_QUERY_INVALID_METHOD="UPDATE RV_REPORT SET R='v';"
# > Select
declare -r TEST_QUERY_INCOMPLETE_SELECT="SELECT CampaignId;"
declare -r TEST_QUERY_NO_TABLE_SELECT="SELECT CampaignId FROM;"
declare -r TEST_QUERY_UNKNOWN_TABLE_SELECT="SELECT CampaignId FROM RV_REPORT;"
declare -r TEST_QUERY_BASIC_SELECT_WITH_NO_ENDING="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT"
declare -r TEST_QUERY_BASIC_SELECT="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT;"
declare -r TEST_QUERY_BASIC_REQUEST='([QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [STATEMENT]="SELECT" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [FIELD_NAMES]="CampaignId" [AWQL_QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId" )'
declare -r TEST_QUERY_VERTICAL_REQUEST='([QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [STATEMENT]="SELECT" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [FIELD_NAMES]="CampaignId" [AWQL_QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [VERTICAL_MODE]="1" [DEBUG]="0" [FIELDS]="CampaignId" )'
declare -r TEST_QUERY_VERTICAL_LOWER_SELECT="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT\g"
declare -r TEST_QUERY_VERTICAL_UPPER_SELECT="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT\G"
declare -r TEST_QUERY_WHERE_SELECT="SELECT CampaignId, CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0;"
declare -r TEST_QUERY_WHERE_REQUEST='([QUERY]="SELECT CampaignId, CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0" [STATEMENT]="SELECT" [WHERE]="Impressions > 0" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [FIELD_NAMES]="CampaignId CampaignName" [AWQL_QUERY]="SELECT CampaignId,CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId CampaignName" )'
declare -r TEST_QUERY_DURING_SELECT="SELECT CampaignId, CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 DURING 20160412,20160413;"
declare -r TEST_QUERY_DURING_REQUEST='([QUERY]="SELECT CampaignId, CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 DURING 20160412,20160413" [STATEMENT]="SELECT" [WHERE]="Impressions > 0" [DURING]="20160412 20160413" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [FIELD_NAMES]="CampaignId CampaignName" [AWQL_QUERY]="SELECT CampaignId,CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 DURING 20160412,20160413" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId CampaignName" )'
declare -r TEST_QUERY_LITERAL_DURING_SELECT="SELECT CampaignId, CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 DURING YESTERDAY;"
declare -r TEST_QUERY_LITERAL_DURING_REQUEST='([QUERY]="SELECT CampaignId, CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 DURING YESTERDAY" [STATEMENT]="SELECT" [WHERE]="Impressions > 0" [DURING]="YESTERDAY" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [FIELD_NAMES]="CampaignId CampaignName" [AWQL_QUERY]="SELECT CampaignId,CampaignName FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 DURING YESTERDAY" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId CampaignName" )'
declare -r TEST_QUERY_COMPLEX_SELECT="SELECT CampaignId, CampaignName, Cost FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 ORDER BY Cost DESC;"
declare -r TEST_QUERY_COMPLEX_REQUEST='([QUERY]="SELECT CampaignId, CampaignName, Cost FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 ORDER BY Cost DESC" [STATEMENT]="SELECT" [WHERE]="Impressions > 0" [ORDER]="Cost DESC" [SORT_ORDER]="n 3 1" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [FIELD_NAMES]="CampaignId CampaignName Cost" [AWQL_QUERY]="SELECT CampaignId,CampaignName,Cost FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId CampaignName Cost" )'
declare -r TEST_QUERY_COMPLETE_SELECT="SELECT CampaignId, CampaignName, Cost FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 DURING YESTERDAY ORDER BY 2 ASC LIMIT 5;"
declare -r TEST_QUERY_COMPLETE_REQUEST='([QUERY]="SELECT CampaignId, CampaignName, Cost FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 DURING YESTERDAY ORDER BY 2 ASC LIMIT 5" [STATEMENT]="SELECT" [WHERE]="Impressions > 0" [DURING]="YESTERDAY" [ORDER]="2 ASC" [SORT_ORDER]="d 2 0" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [FIELD_NAMES]="CampaignId CampaignName Cost" [LIMIT]="5" [AWQL_QUERY]="SELECT CampaignId,CampaignName,Cost FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 DURING YESTERDAY" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId CampaignName Cost" )'
declare -r TEST_QUERY_ORDERS_SELECT="SELECT CampaignId, CampaignName, Cost FROM CAMPAIGN_PERFORMANCE_REPORT WHERE Impressions > 0 ORDER BY Cost DESC, CampaignName ASC;"
declare -r TEST_QUERY_REQUEST='([CHECKSUM]="3092823014" [HEADERS]="" [VIEW]="0" [QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [STATEMENT]="SELECT" [AGGREGATES]="()" [GROUP]="" [METHOD]="select" [RAW]="0" [VERBOSE]="0" [ACCESS_TOKEN]="" [ADWORDS_ID]="123-456-7890" [ORDER]="" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [CACHING]="0" [FIELD_NAMES]="CampaignId" [AWQL_QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [DEVELOPER_TOKEN]="" [API_VERSION]="v201605" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId" )'
declare -r TEST_QUERY_CACHED_REQUEST='([CHECKSUM]="3092823014" [HEADERS]="" [VIEW]="0" [QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [STATEMENT]="SELECT" [AGGREGATES]="()" [GROUP]="" [METHOD]="select" [RAW]="0" [VERBOSE]="0" [ACCESS_TOKEN]="" [ADWORDS_ID]="123-456-7890" [ORDER]="" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [CACHING]="1" [FIELD_NAMES]="CampaignId" [AWQL_QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [DEVELOPER_TOKEN]="" [API_VERSION]="v201605" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId" )'
declare -r TEST_QUERY_VERBOSE_REQUEST='([CHECKSUM]="3092823014" [HEADERS]="" [VIEW]="0" [QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [STATEMENT]="SELECT" [AGGREGATES]="()" [GROUP]="" [METHOD]="select" [RAW]="0" [VERBOSE]="1" [ACCESS_TOKEN]="" [ADWORDS_ID]="123-456-7890" [ORDER]="" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [CACHING]="0" [FIELD_NAMES]="CampaignId" [AWQL_QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [DEVELOPER_TOKEN]="" [API_VERSION]="v201605" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId" )'
declare -r TEST_QUERY_RAW_REQUEST='([CHECKSUM]="3092823014" [HEADERS]="" [VIEW]="0" [QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [STATEMENT]="SELECT" [AGGREGATES]="()" [GROUP]="" [METHOD]="select" [RAW]="1" [VERBOSE]="0" [ACCESS_TOKEN]="" [ADWORDS_ID]="123-456-7890" [ORDER]="" [TABLE]="CAMPAIGN_PERFORMANCE_REPORT" [CACHING]="0" [FIELD_NAMES]="CampaignId" [AWQL_QUERY]="SELECT CampaignId FROM CAMPAIGN_PERFORMANCE_REPORT" [DEVELOPER_TOKEN]="" [API_VERSION]="v201605" [VERTICAL_MODE]="0" [DEBUG]="0" [FIELDS]="CampaignId" )'


readonly TEST_QUERY_TO_REQUEST="-21"

function test_queryToRequest ()
{
    local test

    # Check nothing
    test=$(__queryToRequest)
    echo -n "-$?"
    [[ -z "$test" ]] && echo -n 1
}


readonly TEST_QUERY_WITHOUT_DISPLAY_MODE="-11-11-11-01-01"

function test_queryWithoutDisplayMode ()
{
    local test

    # Check nothing
    test=$(__queryWithoutDisplayMode)
    echo -n "-$?"
    [[ -z "$test" ]] && echo -n 1

    # Check without semicolon or \g
    test=$(__queryWithoutDisplayMode "${TEST_QUERY_BASIC_SELECT_WITH_NO_ENDING}")
    echo -n "-$?"
    [[ "$test" == "${TEST_QUERY_BASIC_SELECT_WITH_NO_ENDING}" ]] && echo -n 1

    # Check with semicolon as ending char
    test=$(__queryWithoutDisplayMode "${TEST_QUERY_BASIC_SELECT}")
    echo -n "-$?"
    [[ "$test" == "${TEST_QUERY_BASIC_SELECT_WITH_NO_ENDING}" ]] && echo -n 1

    # Check with vertical mode pattern in lower case as end
    test=$(__queryWithoutDisplayMode "${TEST_QUERY_VERTICAL_LOWER_SELECT}")
    echo -n "-$?"
    [[ "$test" == "${TEST_QUERY_BASIC_SELECT_WITH_NO_ENDING}" ]] && echo -n 1

    # Check with vertical mode pattern in upper case as end
    test=$(__queryWithoutDisplayMode "${TEST_QUERY_VERTICAL_UPPER_SELECT}")
    echo -n "-$?"
    [[ "$test" == "${TEST_QUERY_BASIC_SELECT_WITH_NO_ENDING}" ]] && echo -n 1
}


readonly TEST_HELP_QUERY="-21"

function test_awqlHelpQuery ()
{
    local test

    # Check nothing
    test=$(awqlHelpQuery)
    echo -n "-$?"
    [[ -n "$test" && "$test" == *"Hervé GOUCHET"* ]] && echo -n 1
}


readonly TEST_AWQL_REQUEST="-11-11-21-11-11-01-01-01-21-21-21-11-11-21-01"

function test_awqlRequest ()
{
    local test

    #1 Check nothing
    test=$(awqlRequest)
    echo -n "-$?"
    [[ "$test" == "${AWQL_INTERNAL_ERROR_ID}" ]] && echo -n 1

    #2 Check with invalid adwords Id
    test=$(awqlRequest "rv")
    echo -n "-$?"
    [[ "$test" == "${AWQL_INTERNAL_ERROR_ID}" ]] && echo -n 1

    #3 Check with valid adwords Id
    test=$(awqlRequest "${TEST_QUERY_API_ID}")
    echo -n "-$?"
    [[ -z "$test" ]] && echo -n 1

    #4 Check with valid adwords Id and query
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${TEST_QUERY_BASIC_SELECT}")
    echo -n "-$?"
    [[ "$test" == "${AWQL_INTERNAL_ERROR_API_VERSION}" ]] && echo -n 1

    #5 Check with valid adwords Id, query but invalid api version
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${TEST_QUERY_BASIC_SELECT}" "rv")
    echo -n "-$?"
    [[ "$test" == "${AWQL_INTERNAL_ERROR_API_VERSION}" ]] && echo -n 1

    #6 Check with valid adwords Id, query and api version
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${TEST_QUERY_BASIC_SELECT}" "${TEST_QUERY_API_VERSION}")
    echo -n "-$?"
    [[ "$test" == "${TEST_QUERY_REQUEST}" ]] && echo -n 1

    #7 Check with valid adwords Id, query and api version. Enable cache
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${TEST_QUERY_BASIC_SELECT}" "${TEST_QUERY_API_VERSION}" 1)
    echo -n "-$?"
    [[ "$test" == "${TEST_QUERY_CACHED_REQUEST}" ]] && echo -n 1

    #8 Check with valid adwords Id, query and api version. Enable verbose mode
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${TEST_QUERY_BASIC_SELECT}" "${TEST_QUERY_API_VERSION}" 0 1)
    echo -n "-$?"
    [[ "$test" == "${TEST_QUERY_VERBOSE_REQUEST}" ]] && echo -n 1

    #9 Check with valid adwords Id and api version but unknown query type
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${TEST_QUERY_INVALID_METHOD}" "${TEST_QUERY_API_VERSION}")
    echo -n "-$?"
    [[ "$test" == "${AWQL_QUERY_ERROR_METHOD}" ]] && echo -n 1

    #10 Check with valid adwords Id and api version but empty query
    test=$(awqlRequest "${TEST_QUERY_API_ID}" ";" "${TEST_QUERY_API_VERSION}")
    echo -n "-$?"
    [[ -z "$test" ]] && echo -n 1

    #11 Check with valid adwords Id and api version but empty vertical query
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "\g" "${TEST_QUERY_API_VERSION}")
    echo -n "-$?"
    [[ -z "$test" ]] && echo -n 1

    #12 Check with valid adwords Id and api version and request to exit
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${AWQL_TEXT_COMMAND_EXIT};" "${TEST_QUERY_API_VERSION}")
    echo -n "-$?"
    [[ "$test" == "${AWQL_PROMPT_EXIT}" ]] && echo -n 1

    #13 Check with valid adwords Id and api version and request to quit
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${AWQL_TEXT_COMMAND_QUIT};" "${TEST_QUERY_API_VERSION}")
    echo -n "-$?"
    [[ "$test" == "${AWQL_PROMPT_EXIT}" ]] && echo -n 1

    #14 Check with valid adwords Id and api version and request to help
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${AWQL_TEXT_COMMAND_HELP};" "${TEST_QUERY_API_VERSION}")
    echo -n "-$?"
    [[ -n "$test" && "$test" == *"Hervé GOUCHET"* ]] && echo -n 1

    #15 Check with valid adwords Id, query and api version. Enable raw mode
    test=$(awqlRequest "${TEST_QUERY_API_ID}" "${TEST_QUERY_BASIC_SELECT}" "${TEST_QUERY_API_VERSION}" 0 0 1)
    echo -n "-$?"
    [[ "$test" == "${TEST_QUERY_RAW_REQUEST}" ]] && echo -n 1
}


# Launch all functional tests
bashUnit "__queryToRequest" "${TEST_QUERY_TO_REQUEST}" "$(test_queryToRequest)"
bashUnit "__queryWithoutDisplayMode" "${TEST_QUERY_WITHOUT_DISPLAY_MODE}" "$(test_queryWithoutDisplayMode)"
bashUnit "awqlHelpQuery" "${TEST_HELP_QUERY}" "$(test_awqlHelpQuery)"
bashUnit "awqlRequest" "${TEST_AWQL_REQUEST}" "$(test_awqlRequest)"