Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B20D8C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 May 2022 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MqHHFBMT3we4WYngRsglZuXxhZGRmHdejM5nql08Iec=;
 b=TgCRPaQiX+9hGn64MBGQsQ+SF3xY/FzDPMNk19exNKO1OgKj2qJfn317D5sN911SfLPA1+imElVf
   E4VO8Yxy1t/Ub0dGC4MiZoiH9jurx2pg7H8mu0E5T4a79m0gyBaCHenfi1SzCWO2TAK13p23l+PM
   i59E55Xq2+fcRkzjs0SumcyQV1XNCPPSN1LK3/CXIaSLK7kCfnZkL+4bzmv90GYL72bAzd2tzVCC
   uC0Z8mjyvRnwfEUZHBxhadrz/7TsU0IRM3+Phpfe/ZGZSCWKSWBM3ewIfKeqMaIFMUn1VK1PUBbL
   CpN24LM4hc3QKvXO8h5UG5wEyIMYL8e0rcP2KA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=MqHHFBMT3we4WYngRsglZuXxhZGRmHdejM5nql08Iec=;
 b=a3kIBlMGCb6RIQhp0jl84U/sx0YaKvQU5ixVwahBz2Khgwx7U+M5BRIhaTJGxzr54kLlP4T37Tf9
   KpPyzGrLkE30MR5/Bx4jo5BMiJHZTpLrfNVIsW1L1fyAt+DuzSKfUdbuWCC10Btc3gBL4ehpfrXV
   IeX9wkEC5lYEtk2k/nhAd7GPtljcncrLX/NNKsGsBXMMGhLaGCdmNDVL5gwOxWK6KbZ/OkQwqzWe
   irLx5lCHDC+XMgmadO9CaVQsK+ZuEQhrGzc4xnL96MMw3OOItDxno2EhM2LEU/ce8ZsKcquMVnMp
   h510m9KfH44UyuuhU2xyu8roRn+DCuJrCFsWVA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220413 64bit (built Apr 13
 2022))
 with ESMTPS id <0RBZ0074SHUI2690@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 May 2022 16:30:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
 h=message-id : date : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=aqY9cJ3SYeWRY3WCw01qPW9fZgqW7/HwQpXuDZ+s3ho=;
 b=Y1S3XTM/9iZbQUGat0Mu0Ol0skVdcC03X6MvsWw1r+qqs5HIZV8KhTK19jKi1Y2G4u90
 vyefY6CvM/pnSfWMnJxV8CHz5a26YNuyYp5Mwd9lSJM4DJlxkBgXVVOWoIHMu+AIVKoi
 sod1nGybd7YKYr+s6Tz1Lk88flBMuK8zmPJERkHVz073uJddd/K3k5XHSywfQ4Lj6vmY
 NsBsZ/m+CagM50c6ENVAHs3WR1s2hIwHBY3r4gbKT5MHueTAlk9HY92G1QjfksLRW439
 v/zYI/1GfUVRM++y2hK5uV0EpQBTJEz4oaWrXKZMdiCdXmqdPsaSnTefT5VRSmFflITY VA==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYQaPX3p4KrGJekDE/BS+brO0sIO5q8SX6AEnk/XLGVfksI+gfQFQBqh3rstyBlNBKLp2/QKn64bUmMWYDLFVGNxrTPaM6ypBPes7FskllaOkqkaGRRPolue4jln0609Wnao4gBblyRTE5AIgaUfXc1Dvm9bWkYDtBoanCeDwHUuKWTz5gS4SreXS6VYUCWnQSPUutZ+oD+Utm28jiL/RPgBaDdL9QvLdYbVrQ0sXaZvmW4/DmWREb/25gxHnlEDWesqrabL/P3Po3tDTzueV6LARPzGz5FWmHp0nzjWVAanmE5bg8BNW0fXoZl7/02/h4nFVHhV4O1tD4e1ZJlW/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aqY9cJ3SYeWRY3WCw01qPW9fZgqW7/HwQpXuDZ+s3ho=;
 b=c7z7vLV9TPxldHMSnRXzbAtRJ8VbCtPLZqU/oY4nm//JhPV4i2gAcGxOY199XQfKpxyyw70mt9n/JBhYYDTNu9Rnbs13SCAA6DZrgYpp1M+fdrbDvMz2iZeHWlV1/G2PZ9osjszS+Epxhwx4QVHeleFYt/7uO5WkJME6vbowvv2RKBFeZOwNWBF0WXkskgBaDILVTemLsk+prCA1gnPfT+bP2lbF1ipK0WQEbB6k2h4SkxyJZdlwMaLIQQwJGtrXx0ew/HCsgn+DiiBmRliV5mo7RcoviPXICTjgWz0m6cDi2pwQaxRaIxjJEuMwDZwmcF7c2zbPDXjYxKokBii7vA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aqY9cJ3SYeWRY3WCw01qPW9fZgqW7/HwQpXuDZ+s3ho=;
 b=rB6vBqxfc976Ro6aZ7sJWA0B4iLrerx6SEyRINfRzmVMWKk9gvJaa89vnRjPTrfynsUYtLXC9uYsu649JQAcw07ptodAzTMzOtUF3L89P5E0ad7WDk26Y/T4anUeGarwRqjzPJiuXBq/zt4vnxyeuAHheAxtVsLT/gHn04mKgfI=
Message-id: <cc181847-abc9-f6b4-fca0-8d59d0ad1d7c@oracle.com>
Date: Mon, 16 May 2022 09:30:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220510232213.23435-1-junxiao.bi@oracle.com>
 <cde723f1-db5b-d912-580e-04ddf6a0810a@linux.alibaba.com>
 <7511d9c1-c725-734b-a730-d493ddc37b43@oracle.com>
 <7b620c53-0c45-da2c-829e-26195cbe7d4e@linux.alibaba.com>
In-reply-to: <7b620c53-0c45-da2c-829e-26195cbe7d4e@linux.alibaba.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 16:30:07.4872 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,
 18.0.858 definitions=2022-05-16_15:2022-05-16, 2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160092
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: dlmfs: not clear
 USER_LOCK_ATTACHED when destroy lock
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
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Junxiao Bi <junxiao.bi@oracle.com>
Content-transfer-encoding: 7bit
Content-type: text/plain; charset="us-ascii"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SJ0PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:a03:338::26) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6974e2ae-a99f-4ef1-88d5-08da37595691
X-MS-TrafficTypeDiagnostic: SA1PR10MB5510:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 wpTimO888urL6l7O4qm8lalfjYxMFPKjoQmPs9pcLTpYDUmeyITtX0aqxI3G280gzpfcfNjrhrXMw8W2+SFaQIOzXa73HW5zIojQdvEgoYXagy2mtxShV7c+iFRAXbpuU2qLoTaP9JtkeghW+MjlVllVwg69Tzb14mdwCo+aWMtiTewx0NtdzTz5NapoM7+SXQMrHG4JoRnD6lwb9NOM80r803GjlwOWnbnJAlR4nEJkrzYrykJFkC4ELyit8nvyM3z6uzzdQgj9J/5nFQ5Xy4AfGxW6wt94TuxLMIrWaoFMHfsDb2MsMECugRRiyLDbOXw91LVV2Fl6jqW4pwAS8Ela+hOpQENowr065zlwmrd6gBQnmQJgLhlV0LxuRD/pqUiyDwTsDF1rKkgBDMmtxXYC4Z85CrC1tCdw3hfWaCbFvC9Vw321s9x+E71pwKPyWhlFqhR+K5yBYHot+KX9qTPmGPBD56Fm2fG1qlX3oo4gYFs2XDaPxzWiAGSV9zUzj6KoDOkNpi/HUuSjO3NUGi8Zm8hc25HPaqn9HOwVI4wMHAMO+9blppmEKcp6duGWEl45HsT1PraBwXA9yFWxqw==
X-MS-Exchange-CrossTenant-Network-Message-Id:
 6974e2ae-a99f-4ef1-88d5-08da37595691
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Tp0yF/Xl5rQwB9bw5du9r06Uez6sS9viFrNWsC8XVXqZau9bp3mg+NTSOU9DGfq1wFL2wW0yQYKi08QH3PA4Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5510
X-Proofpoint-GUID: ZXKNC7hPm-dFBGvM1ndJRTnf9ir94MgY
X-Proofpoint-ORIG-GUID: ZXKNC7hPm-dFBGvM1ndJRTnf9ir94MgY
Reporting-Meta:
 AAF9bOilSsjC5BHAp/B/VS0lwnI2Lk1JII/Al0tzu0aV0poGs9KvwNVF0fCEn5n+
 CervYcK8xAPTWLTKCZQ1Qvtnal+UR6XPyskFvQNV/4DX9zZb6gfKH4Z5PyP+NdBU
 PTmDBwEGH9uy+8q87Olc/8CzQZS/+Hv/rNXfIw2a0n3fZOiDI1fV0c33jfQsRVhI
 9te2fvvV9iCh84h7m1rKsXjhlfTZgPLRnfQii1kZmSK+8CMQ4arPYOYZbxtvV4DA
 xlp+8EAoaasuBbaR4Rxiib1nNnk+3IhQy2640vitSIF3svFr3jKXuNviXgs+kHR1
 W7bTnzenGwkky6qR9CNIkSl7NQ72nMxoAHXYbLp08ucFgpyN/PuEZrnVLqikB3Nz
 7Tu91vv/a5nzn/71kGhJkweklKWN2CgMlU5Ru/XghqB+GpOoNCI/ZplPzeLlGasr
 oVt7QOb6nIk6gSPflf33YaXO5I20jYKyYE66l6it8064DxJ7o6AVlptZ6VJMEl5f
 vmUjQG4puooCzagzXVSV+fWrj6rSW8LnHNnkuimd873Z


On 5/15/22 7:57 AM, Joseph Qi wrote:
>
> On 5/14/22 12:27 AM, Junxiao Bi wrote:
>> On 5/12/22 7:05 PM, Joseph Qi wrote:
>>
>>> On 5/11/22 7:22 AM, Junxiao Bi wrote:
>>>> The following function is the only place that check USER_LOCK_ATTACHED,
>>>> this flag is set when lock request is granted through user_bast() and
>>>> only the following function will clear it.
>>>>
>>> user_ast?
>> Good catch, that's a typo, should be user_ast.
>>>> Checking of this flag here is to make sure ocfs2_dlm_unlock is not
>>>> issued if this lock is never granted. For example, lock file is created
>>>> and then get removed, open file never happens.
>>>>
>>>> Clearing the flag here is not necessary because this is the only function
>>>> that checks it, if another flow is executing user_dlm_destroy_lock(), it
>>>> will bail out at the beginning because of USER_LOCK_IN_TEARDOWN and never
>>>> check USER_LOCK_ATTACHED.
>>>> Drop the clear, so we don't need take care it for the following
>>>> error handling patch.
>>>>
>>> Seems it depends on initializing lockres every time, but it seems this
>>> is not true for directory now.
>> Sorry, i didn't get this. Can you elaborate this?
>>
> lockres may be reused and if we don't reinitialized, the left flag can
> cause unexpected behavior.

I don't know how it could get reused since it's going to be removed. 
Anyway USER_LOCK_IN_TEARDOWN is still set in lockres. All the flow will 
bail out because of this flag.

Thanks,

Junxiao.

>
> Thanks,
> Joseph

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
