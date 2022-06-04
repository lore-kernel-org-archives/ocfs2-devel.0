Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3949DC433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat,  4 Jun 2022 10:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AHl0LJamwqQ9LtGBXtzYG7gGPCr7+MHSmpic0nQtfTI=;
 b=Xlw18FR6hCh2CZEweQWgZJDZoPckVWKt3UN1rKdLJnlj6MHtVe/E+RBp7jvkuenJUymxmRQysNJL
   DQJml2CM9BaaZDtgWL7vVZzruAUnt7eGDt01V1SAgUdPBLcrQlixgL/wWccON/fSJ9Z2pt1yCjAL
   vVtiLhyKVi40ku7bmOv2rZdayeMuUVxhtpUMyWbuy36Yfl6DifqeTPytJ9a9nQvtsoxnq2OUpE6n
   PWqJryxuCXyO3yss7dqvdwNC4UnkoUpcowOr5C/4j4gD2KstSWR2aeJjt04rXIDf6vkVsYp+SPsw
   XjK56CCMHgDXGpgfVY3zvKa+Msgmzb/vjkzvDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AHl0LJamwqQ9LtGBXtzYG7gGPCr7+MHSmpic0nQtfTI=;
 b=Kib0jUtlvOIL7aEx/bLDm0jxrIArmrlw5MMZ1W9Th+KXhBrARtpO/MPN9DTW92De/95K0vsZFtcX
   KRm357D6ec7qT7+gC9Y/a62pCdkuYs1AQ9wVfAySsdwaUsLGjX8UWBkSmGmiOySiD69rutj+GhOC
   vWfIaKZccNirg9euMx069nfriOlOcWXidf4V6cjzbZhDyxWl/fY93bah7GlpzTLEyC2jz8uK5Mvb
   mUR+PBURZZVs5jF8Zrlbu8AQGusd8LDWEsj67iGR+l84hWLpYusbpyd83KoWF7SHdXD34D8FWjNi
   y8Qw+Y6ZCUVixzZM1AaEvYC4MQwPOhbC3Bw2uA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCY00J1S6XLGG30@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 04 Jun 2022 10:10:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654337416;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=eMqHZrLe7sQPrgQ1pDJ02S6YFNFCT/NSli3GGqYeydA=;
 b=EXhOlYL5XFSd16dLudUvxKZRhPqlV16Pt8DCif1Ko/0cvlPaMKTb8L7jvZccBnJ9Pdkcfl
 hrckgBHQMjKBBoyrykX28pj40Q8INFaRI9TMOy4MyKgOYQ3QUD0ua1heJWCvaX1ZNOf5+s
 ROCmUUUMz/O+ssc2KillDd0loz1GWFY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eg/6J/0ci7OgRnAiCVfgAsiUl36VAGUDq7UibkXG8t/fQRG1AkVzn9KhL8G9cs90JHR/Aa90LubhjSRyM4yDZ216p/YHuhYYMIkfqI9pFSR0zu1wyEylZavcPkq1QIzHoYzUv+jz9OcHSeWHb0PAHddYRONP+wU96Nbz+Z0jOtr9pNBz6S9Oqcev0zDLhR2WfwENIR9GFXNDGOMAD6rSMa+8VvmGjRupkY1/RO4IMm9d8iuPP2/B0C0TB1JKSbtkG2Ey731ovNwE6OJYWfa6kdSeebP006TmXrC0IrZB9XUE3zWOgbDFM/nN1hgZPg22t13rljsZaAjsDTc66Hgqtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMqHZrLe7sQPrgQ1pDJ02S6YFNFCT/NSli3GGqYeydA=;
 b=cT7bLW98gVXWOxRXOrJdLLx0ek0kppRLsrVyWJV8VJWu7+gHJEKtCpyb/77jowh5NiDGCaK7K5aXAFi1gaxlaqqa171+FZdLcCLXvprnZYjsi/+6SyvTWaijJ2IPGjycyugMnYFpCijjtfqnqeIV4596grzvpPb6FGtRnKW3TFS4u4i2EwnwCQDsNTqWrNFZ4w+kMIhOpOQ84zH4ADpfQBFqQK6jjM08AcR2/pLtCn6kfz/cRcggwdI+erQrv25KQLRuE2WvsQ1/s9gK/HJA1XyD8uLzkbilsbsTMtai6E9clKkMd3Gqaqe8N4s9mjeT8TiAWebfGuMGPTPOQLiU2A==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
Message-id: <0b6053a0-8417-7da0-78c7-bf23f6fccba3@suse.com>
Date: Sat, 4 Jun 2022 18:10:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-language: en-US
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20220603223122.43174-1-junxiao.bi@oracle.com>
In-reply-to: <20220603223122.43174-1-junxiao.bi@oracle.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(316002)(508600001)(8936002)(6486002)(5660300002)(86362001)(186003)(2616005)(31696002)(83380400001)(53546011)(2906002)(38100700002)(6666004)(6506007)(6512007)(26005)(8676002)(66946007)(36756003)(66556008)(66476007)(31686004)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 10:10:13.2915 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10367
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=138 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 adultscore=0 bulkscore=0
 clxscore=242 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206040050
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: "heming.zhao--- via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "heming.zhao@suse.com" <heming.zhao@suse.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: M82uaoPNMhCHM8uo3WEenQ-1
X-ClientProxiedBy: SG2P153CA0051.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::20)
 To DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f1e9c9f-4793-4180-61b5-08da46126a1c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6128:EE_
X-Microsoft-Antispam-PRVS:
 <VI1PR04MB61288DD6F38AE0AA21E65F3E97A09@VI1PR04MB6128.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 T55iHS+TlfN1Bha2Bw3zApbaxfXGf4PaW6HWwb7oPuLTDky92YUbQafROohProJ0RHYFHKsf3PEPNCffRVx3eQL8+6ldZfnat011AP85OV3t3Te9zrxiXuhgxZey/y3R6iJwAHjTinRHldUNE0zCJhtokXw5LgUVHV4NXy0ZwpqoxBMyYhfgpxJvgH+bni8uytn3agupBqRpjBf2KSLrosM3GeXSCCWDcertBJlfLbPErxRITBcb61EqsOS7o/OZQF4JLsjhNZ2KB71kThlAHgL+RsxSbR8B1DPDugtw0gfMltOOyUhzJqjg4Lwr2RdVvndL3L41gqRbQRKxKqcgeFTjPxoQowMA3jTxrsCVGSK1LYNEjD2ifgzD77m1XnSoyZQju6sXTTAGxHioMwfCMame/oBqym30Wa2SXMnnli0+r7orEFwIPHFbFUFYxcBgz1sq76bQB6y89Q1tVBFH7u9zaVHqnYlz0swdFtwKVsaTNjGVy5uqMxgPmStsnBV+rGT39Wn0tCeHwvxH5n1l7NyfzUze59YKFaIMQDUxUEWCXbh2TSWz/UXjNEAwTZMVAsGAfO0H2T6QjJyUP007hGCbdo0nvqdIJ9lOZaO3lscgdwwefXeDwvbETp2XhftAPGh+0k0CfbuerizIQUXB6Jedf1UmFQl5W1lBrkzKVog7/Y3uoxkAxxd4S6JVprzHDpbJdDBqogFaVM185gJgDrG7vOziwQpvsa5zSE1rxIQ=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?bFNrYWlUWGVSWnVRRTVjZ1VpZ2g5eExyN0FXLzlneEthRTVyYzdjT1J6Yk1a?=
 =?utf-8?B?SVJ5Y3F3U3dKRlJNKy8xSE5kTWN2dzYyTUpHa3NDMWlWM0tkRi9wYlFWcU5x?=
 =?utf-8?B?VmVwU2s2akdNMTlpbG5OYXRVYkV2d1dYS3AxbGo3a2tmN3R3NmdXK2tHZnk3?=
 =?utf-8?B?djEvYm40aTNkMnNRK0UwWEF3NG9jbElVN2YwL0lIZFZiT09vbWU3eWphL3VI?=
 =?utf-8?B?L3YzWm1kUkd0Qjh0dEF0OG1sdkpPd0t2ZWM3QTVzcGdrQ2IwcGhnMFlLU3c5?=
 =?utf-8?B?TXBZVWJFS290b0VTRzdOc1FyZnp6QkdlREhYeHB3OENzaldFSTFFekp6RDVm?=
 =?utf-8?B?ZEozeVVoTDQ5Ymp0M1E1ZkpoTGQzNU5WcFRHWUNtOXM5NXlsd1VtODRTK09G?=
 =?utf-8?B?VzNrR2tFRkN3dzl4NklDQjBtZFVaVXlNR3V0QjM3TXdJMVZOOWxzNm1JQTlU?=
 =?utf-8?B?MHZXa0tWakNMZ0RsdW5VVk1JMzlXcDVIWU1GVDB0NGNwNFBWQkhqdUJJOEk5?=
 =?utf-8?B?NWNNcFladDlHK0RQdDhtRXh5d3B6ZlI0U3NhQXdrMnlSK3hPM1VXRmtIRmJ6?=
 =?utf-8?B?Q3pkbm5PUHFaVjlISDVBcFJjcUJMOUNPLzUwVUUvcWxUYkNCcUtRbEhLT2w4?=
 =?utf-8?B?aTAzOTN1MktqQUo1LzNJY3J1TzV5bEZsbWVQeDA2N1hNWjhvV2ZMR2pqam5U?=
 =?utf-8?B?Z0V5SEhvQXNiTUZrc2w4MW9iT0t3b2tnOHNzQ0xMamcyRnZVZEZ0WkpjaEti?=
 =?utf-8?B?REkxQnoyQkc1cC9IelpQclV2bEd1WlhiOGpxeXJhbWlVUDlkUUI0czk0TnFI?=
 =?utf-8?B?c29TN3oxMHc4U3J0aWkvdEUrZEFyd0gwRmNkN2VwK0FYanVGQW1wMzlQc2pH?=
 =?utf-8?B?WkcxLzVOR3FhQ00wUk1hY3FxWCs5dWxBQjg2QzR3NC9zQWNMVitndDNib2Z1?=
 =?utf-8?B?M3FQU2d3OWNNb0laZkJLRFFmZVdiZ2tPbVppNFRGZDU2dGJnUEdxdTFtVkVj?=
 =?utf-8?B?cXV0VE5sQVkza1FpMkNhemtxcjdtbVNnbW1PdWdydTFvdk5HbWFPMDgraDdK?=
 =?utf-8?B?UjVmQzFYVFFQUmxvNG50eXhVSWFjRVVFU2NmcjlYeEdvak5zQkpRYmtXQS9w?=
 =?utf-8?B?djdhK0N4dFFNZnpxckhTdGVGMC9id00xK28zdkNmeEhsRW5MWWdtNkVXQTFT?=
 =?utf-8?B?cXNqc2ROME1LSTdSRUhSdjg0WWxiR2M5MzJpT2NrbmFUMjJ1cG9lTGdxNDFn?=
 =?utf-8?B?TVV6L2FLUlUwY1lCb1NxSTlIUmpXeWgwdFpRMVllcVQ0azZzME9PamN6T2hx?=
 =?utf-8?B?dWxzUUFSK0JRVDRqaXAwdGQ2c1JvdWZSUjFsYjlkbzdFcnNZTWNHVSthRGcv?=
 =?utf-8?B?aVEwQnNzUU44VWlnU05UMzgxalIveUhUVFFtKzNCVzlSN056VXBrVjhURnBk?=
 =?utf-8?B?TStzbzBCNElCemR5N09MYk1FaEtEaUhTdG9EVGliM3ZubWk2aC9IZnoya0Zp?=
 =?utf-8?B?QnJHYVROUFJUVE1pNVV1VnErQWZFdzZrZzl4TlFoSVk5UlcwQWtqNWtsL0Zi?=
 =?utf-8?B?WDBIU3oxK1NNNHBjSTFTOXJRc1lrSWVFbzdoSFpzNHJFT3Y2TUlOWTBjUjhm?=
 =?utf-8?B?MHQwWGVlcVZJMEE1dkF3M3ZtZEk3ZUxENzZFRFpPeTdjSkMwaVJJTnJqQVRS?=
 =?utf-8?B?RXR3NWVSempKQXpqaUhieFcwelNYYkxWbzVDVzRsZFVlZ2M0WU9ES2diNUk5?=
 =?utf-8?B?bkdMRHc1NSt3emJQZVRBQmtCemh3K1Vxa3VuTE0vS1hqTVdKbmhNSy9EZE1J?=
 =?utf-8?B?WlFSaUlQTGdWK2lKeFgrMWNIM0FqK2ZJaXFhRzhrRVFrT1BaOUwyUHZIbDFl?=
 =?utf-8?B?R3ptY3JPWVA1VE5pMDNQUnpIQ2J5ZW03WmpqSFNUUnZqYUpKV0xBQ2ZiM0hB?=
 =?utf-8?B?M2QyNHphYVJkV2c0aDJpQ0NMc1kwZGFUdHNNYmlBVVo4T0w5bUN3QWJjR3Q0?=
 =?utf-8?B?cDYxditROExzMksxYUEzYkpNZUJBVGQ2bEg4N3VueWFxOFo3cWFDNWxPZUoy?=
 =?utf-8?B?NmJuNXlmSll4Z2NuZ1BvcHpZNXREMnV2bFZsQUtnWE9Db1hwRUNrSnRyS1Az?=
 =?utf-8?B?dkhPZWdSTFNVeGRMbi9YN0dDVU5LWUx6VmQ5WUhJZjZ2M3c1V2NyOW9Za1Vw?=
 =?utf-8?B?S1dpNzVXdVRrbTN3Z2xQMGtCemxjd2ZmcmV6TFZ5QVExRVNyTk92NGFiazBi?=
 =?utf-8?B?RWhOWEpEN2hVS2k0b1hBWEdLVEF5NHh6bTV3bkdvSE9DUS9hQUxsdmNyOFhL?=
 =?utf-8?B?dUJ4Z3dIRi9veEEwRE52VDJsY2hMOFRaanErWWE3SjlNR25HOW9Sdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 6f1e9c9f-4793-4180-61b5-08da46126a1c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 mRpAy+JFiF8gFWuqJoAmoZ+NK3pxPLlyy7wYzBpQgNbMETUWywi2KcbCD2j1MxyfpGZSgRIWFAGdYjM1Z44peQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6128
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 4Pq-awHrd7BKQepMLyVY7BqxnO-VHBsF
X-Proofpoint-GUID: 4Pq-awHrd7BKQepMLyVY7BqxnO-VHBsF
Reporting-Meta:
 AAHzr8bTkOeyRqMTzZ1GcyYlYBdWe+4vw6A4RzaM59X1mN8mELDrQhPUB1zuDHXN
 4W6l3tDzQQViTfkF4pcvu9daU23c90CbQ99On64PQVybrp0w8IvH0wGQG3q+coTV
 7LBWhia5BjevHWgL+Sg+LOCPLJTAWJLOisLLf0kAl8/HTRwcSX+wGmNVJtvUbiu9
 1kEDBTrlhP3EDGd9vVJOP9lx1zVF/0hnRes9r+Ww+57UFf8Iv2q5qzuGBnW8UTLk
 lnC6bdmtJ524HwdUOq8HtWqzzR2+4aWnbK6HNRyY7ziPiF+LUdgXysmTfTYvRqyA
 TdU4DUehIJw88Tia2r9aJwahn+T5zy19sVDUSv8DfIpVGxYZOAf6PlcMA29QitIz
 VMAj5YYa9MyG0+mi+9M/S98THzKheyDdaE1Y+FUOZK4GUFZzQFBvoPrhJSmjN3cI
 gsNuKIHrL5C2otyeVvNNwqOb3B0Fy94Uzb4COrY99raU8ntqwoQqRrix/aJk3Fg5
 R5mAmDctzn2bDpPe2lr2lwO8xfiz58MWPPqg0Y1dCyw=

Hello Junxiao,

On 6/4/22 06:31, Junxiao Bi via Ocfs2-devel wrote:
> When unlink a dlmfs, first it will invoke dlmfs_unlink(), and then invoke
> dlmfs_evict_inode(), user_dlm_destroy_lock() is invoked in both places,
> the second one from dlmfs_evict_inode() will get EBUSY error because
> USER_LOCK_IN_TEARDOWN is already set in lockres. This doesn't affect
> any function, just the error log is anonying.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>   fs/ocfs2/dlmfs/dlmfs.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index e360543ad7e7..a120610dff7e 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -296,17 +296,25 @@ static void dlmfs_evict_inode(struct inode *inode)
>   {
>   	int status;
>   	struct dlmfs_inode_private *ip;
> +	struct user_lock_res *lockres;
> +	int destroyed;
>   
>   	clear_inode(inode);
>   
>   	mlog(0, "inode %lu\n", inode->i_ino);
>   
>   	ip = DLMFS_I(inode);
> +	lockres = &ip->ip_lockres;
>   
>   	if (S_ISREG(inode->i_mode)) {
> -		status = user_dlm_destroy_lock(&ip->ip_lockres);
> -		if (status < 0)
> -			mlog_errno(status);
> +		spin_lock(&lockres->l_lock);
> +		destroyed = !!(lockres->l_flags & USER_LOCK_IN_TEARDOWN);
> +		spin_unlock(&lockres->l_lock);

This area code does the same work in user_dlm_destroy_lock(). Why not to give another
errno (e.g -EAGAIN) for user_dlm_destroy_lock when l_flags contains USER_LOCK_IN_TEARDOWN.
then change 'if (status < 0)' to 'if (status < 0 && status != -EAGAIN)'

Thanks,
Heming

> +		if (!destroyed) {
> +			status = user_dlm_destroy_lock(lockres);
> +			if (status < 0)
> +				mlog_errno(status);
> +		}
>   		iput(ip->ip_parent);
>   		goto clear_fields;
>   	}


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
