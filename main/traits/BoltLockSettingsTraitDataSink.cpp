/*
 *
 *    Copyright (c) 2019 Google LLC.
 *    All rights reserved.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/**
 *    @file
 *      A trait data sink implementation for the Weave Security BoltLockSettingsTrait.
 *
 */

#include <traits/include/BoltLockSettingsTraitDataSink.h>
#include <schema/include/BoltLockSettingsTrait.h>

#include "nrf_log.h"

using namespace nl::Weave::TLV;
using namespace nl::Weave::Profiles::DataManagement;

using namespace Schema::Weave::Trait::Security;
using namespace Schema::Weave::Trait::Security::BoltLockSettingsTrait;

BoltLockSettingsTraitDataSink::BoltLockSettingsTraitDataSink() : TraitDataSink(&BoltLockSettingsTrait::TraitSchema)
{
    mAutoRelockOn         = false;
    mAutoLockDurationSecs = 0;
}

WEAVE_ERROR
BoltLockSettingsTraitDataSink::SetLeafData(PropertyPathHandle aLeafHandle, TLVReader & aReader)
{
    WEAVE_ERROR err = WEAVE_NO_ERROR;

    switch (aLeafHandle)
    {
        case BoltLockSettingsTrait::kPropertyHandle_AutoRelockOn:
        {
            err = aReader.Get(mAutoRelockOn);
            nlREQUIRE_SUCCESS(err, exit);

            NRF_LOG_INFO("Auto Relock %s", (mAutoRelockOn) ? "ENABLED" : "DISABLED");
            break;
        }

        case BoltLockSettingsTrait::kPropertyHandle_AutoRelockDuration:
        {
            err = aReader.Get(mAutoLockDurationSecs);
            nlREQUIRE_SUCCESS(err, exit);

            NRF_LOG_INFO("Auto Relock On Duration (secs): %u", mAutoLockDurationSecs);
            break;
        }

        default:
            break;
    }

exit:
    return err;
}