Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7359C67871
	for <ocfs2-devel@archiver.kernel.org>; Tue, 25 Oct 2022 02:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Ugo3M/cu3PT/bp1cYJQUcSUxJwuzlTp4Xt33VtBJdvA=;
 b=ucC4aEENo6OQpQhICyojV0JHCF9onYVbk11aJFg0UdNfYjdopvU+PHPZvqG/M1KaCNtqSyTXm2aL
   G2PNEDTUEpAxdv/6z0gXGYIeH2mNHoy9notxgjAaOo3vSC7ms2WEw4FinupV/AXDrDK3mw8Z7Ofj
   B4YDkfHQaf1d8jdi/SJtJ1+CC1g2hLrv3Xs2qOBl9W3Ov4CoFbqIkVd6DYqUTt8KoTES8IgxTUym
   7vxE+HuAZzLGOqbPBJYDGeDjQwblv7XTSkjoWJLx7E/XnF58GtneaT6dTvzl+qKXxwdNdfiO8k9c
   jRQCWmnAZg9NLlsm6l4mQUaL9q5wS/kLzPXw1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Ugo3M/cu3PT/bp1cYJQUcSUxJwuzlTp4Xt33VtBJdvA=;
 b=R1qg8gDGajlRzuZG+GAl7YQGkjlrL/4qZdr8ljAATHziNuPngy4BOnzTLnMFoy8UemJn2mrutHOk
   e1XP6h4Y3m/U8wwVjaaumnEeItUETN6Hdtlg81h50U6YLKl3ojyvy3R5c5gVCCs41bFMRok5D0/d
   7VeTv0fRWvCW5odkaIFcMbvC8qTMb/sw6XOgaqRCHa+tpVFVVzjM8rmNne+aiguL1f2wnzg0Ojhn
   KgZQbbKJzr+cKTnfaBxqxSsqrNM+JxPOxg41btbMFl5wNXtTezcHChXPyxfujHxP1IhhEAjvSpjg
   LpuxWP5gnlgBTyo0DtZKksV10nW9L2HmuDHGVg==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RKA00EK7G2ANL80@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 25 Oct 2022 02:54:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXABH+xc7pAFvC0238xMgcdn9t/F1UW74ZX5ttHyBMQhcc/kD9jRZYLmDol1HD6d7NkmA+JaSGBIFX9wmC0fI3v/+idQmabED5RphTaf3LSgy7ZTzUgUoRJUF+LAAqK0J6ztEhuSVkFBU39td7DqOD9+izIzss3clh3aUHiM8hIfaugce122rCzZLMoIo4Eff6PNQKFM64BTU1FGX9MeVI4MxbkxJJi3Zq07YNksukyL+PVUNmluEYEJGoJCV/dhYwwYUEyWlraWG9OBS0yfbp8s9yl0H1HlLcK/fxROCeS+fSgwLxhdFwTMiWjR7KuziutjXoBHqEZGhBPNMWDbTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7NBY9ipv5YwqEHDXRYBVzed/xLjTDkOqX4rE6JdQyw=;
 b=MT7gvdcye8Wyx2tuawiVJ9UdYfe5LrkX2aejCTjof+7YVaSbpl+EQyck6nZ0hczEdJ1wP1J2zH8tOEflrUri9j2OF10FX5bJ7o5d1KCDMqVtat0qqoSIBTBGovn+UQ1e0tF+jRsrIqAL9G8OBKXI+Utd9JjFQclJqrYeNjinsUuoz8xXAGBRcshYcP6z4JzItP4GTsjYxhOi27tETwTLOwWImBXZDJxZMZkT3Nj1f97AiwVmWl+XooYYava0tAXNUr038jQ9zMA06on31lYA5jjSZ/4HjmuE9zxKL2VkBQChlEvRhQTzJ6EuHGAueSD4n52zcYZ3Z0mEckLbuKZALA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7NBY9ipv5YwqEHDXRYBVzed/xLjTDkOqX4rE6JdQyw=;
 b=Se5QShH56qEXMODLTBZgP5G19uOIB5/YHiu21fa6RwGHUbtaX3K63ucU0rndZ4NK/V6S7TxeesfHQ73xn5zsIT6rZ8bHLWzbUoh21oHOr0mj2P+9/zt9XF0ADSL9ZK8Lzxb6HdCBxlY2Zh3VmsAJqbZDbKkBtzIhXHxo6iBeaM8=
Message-id: <aca964ca-c9de-4d86-0e95-254575db4315@amd.com>
Date: Mon, 24 Oct 2022 22:53:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-language: en-CA
To: Yang Yingliang <yangyingliang@huawei.com>, linux-kernel@vger.kernel.org,
 qemu-devel@nongnu.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com,
 linux-mtd@lists.infradead.org, amd-gfx@lists.freedesktop.org
References: <20221024121910.1169801-1-yangyingliang@huawei.com>
In-reply-to: <20221024121910.1169801-1-yangyingliang@huawei.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM6PR12MB3370.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(6666004)(66556008)(6506007)(66476007)(4326008)(66946007)(7416002)(6512007)(8936002)(36756003)(53546011)(5660300002)(26005)(8676002)(41300700001)(316002)(86362001)(83380400001)(4001150100001)(31696002)(2906002)(38100700002)(44832011)(186003)(2616005)(478600001)(31686004)(6486002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 02:53:54.5222 (UTC)
X-Source-IP: 40.107.243.83
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10510
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 adultscore=0 clxscore=174 lowpriorityscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=219 mlxscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250015 domainage_hfrom=13126
Cc: alexander.deucher@amd.com, richard@nod.at, mst@redhat.com,
 gregkh@linuxfoundation.org, somlo@cmu.edu, chao@kernel.org,
 huangjianan@oppo.com, liushixin2@huawei.com, hsiangkao@linux.alibaba.com,
 rafael@kernel.org, jaegeuk@kernel.org
Subject: Re: [Ocfs2-devel] [PATCH v2] kset: fix memory leak when
 kset_register() returns error
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
From: Luben Tuikov via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Luben Tuikov <luben.tuikov@amd.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: YT1PR01CA0113.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::22) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|BL1PR12MB5192:EE_
X-MS-Office365-Filtering-Correlation-Id: ba67d978-a8bf-4431-21c8-08dab634277c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 Rg4JmRzCyskyoj1/Jgb4MVeT306WDkjZEU5luFQJ/CcvIjAAOUZ06o8RM++2KlL+nD9MfIslBcJrlydoa812RLwLq/NA78q9cqKRqAuQ2tAsgn03CZe89sIC0AZnnZ9DinmaYsnAlRx+N01lbHOAnpc85l/QO6SBiTY1UYVnTXywu/spP9YkMr9PCp8gBvDLlMiYmvoXqqQkWcVsdMBbpOOoGnIyVxyC8A7spI6pRSFMehcWSprM8VnG7n2odLQSVGfd1z0zcJh4PYgJqTflH0PmDit6+HyvlZpnLPzIf7YTNleP+Z/tJsYIG5nlmTtpOhlxMaAYZds4Om0pmaDgoTicmy23v3+V0XKD98r0WG1Hchp/aSPrWWuk54KZx4PI2zeK2M21BqY1rGGFvRB8J4E9JPANSADouL63T+jo+roexHvF0Pn1cTawi/pY+sNtxvfta8toCkIcT1S51CJBHD6yat+IwDP8KBsmpkCOz3QxWiw+DYGw1PFHrabpeVIJ6JWTFny0sFscRmHtgQPk+EdOgrhCzh/y5Qf5BOSwJksHBSsyAHqzlSlTi5zMXKF38rP4Wu+7fEqUkYwqbQSxzzYznBx6YoSHN9mN4HJ6KdOds2AfLv3lyAysdJ56wdRvRKn7gyLPexSBXV62300Z+LTJhr785LNaZiwlPvYjbb8iRFBoqBWIGe954rmnsqfZ2xA1EHjJZJxXBlxJWsZI3KZSuGaywO69Ch/jwxY7QAu6x/++JA0HGVsEC/4ISMWU54F/4u7qZUlTfigpPyv6/up4+nZMYAi98U4qe2haOyg=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ZDAzZG5lYy9hdVNvVmpSQk1xQmdtK0dDTFl4Y25wS1QydUh1aHZFalZwRVZ4?=
 =?utf-8?B?ZEJ0U0gvV2ZWanhDUFlPVDF1TDRzd01XVVNCd0tQeUQ4d21FbWpJWmx3WlMx?=
 =?utf-8?B?elhGN3lNR2JNUkdYUlJ2Y0ZjN3FENkJaSXRMMlgvVVlJNTRBTllFd1FSS2hD?=
 =?utf-8?B?VnBScnNSR0xHbVdmTVVKcGNwV1pQQXk4aWRFQTZkN0FuRTRmdmw4bXRaNXJl?=
 =?utf-8?B?azZRRFUxd0hXSlQvOTVRbHZWMlBhVnVSZGZmTWFGNTkzVXFLbmtIM0F6MzE0?=
 =?utf-8?B?djlNZ2RhRzVrVDBDMEtHTGVaOHJ5S1JZU0VIMytjQTVkaWljcWVBcmNGc0Nw?=
 =?utf-8?B?VEhqT3Z5VmVpTkdyTlN4d3YxL25iSnJxYVNLM1ZPbWpvVGFxVktDaUFZcmJn?=
 =?utf-8?B?Qno5bmtwUlR4MjlIQjNWOTJZdjBqZmFmODdCaERKeXpNZEdTaDBteGIvNmNt?=
 =?utf-8?B?V3QvQUtLUmVhV3p6OFBXNWVTTUEzNTBIa2FRdVpZSlEwdVAxZlJJMDJQbmNq?=
 =?utf-8?B?djgya1FQbHNTNkUvQTJaVGxnanU4ak1ZN1NjZENvWlBwaFdJZVFnODRCN3By?=
 =?utf-8?B?SlJLVmNzNStKcFBwSjQrZjlybWJCTzVRWmFxc25YL0lwa2xEYTB5aFZjK21w?=
 =?utf-8?B?dWlvMG9nSENhM2xjSTh5SEtTeFhrbUxRNEg2cndmUDhjeGZ3VmlNc3p3Rk1Z?=
 =?utf-8?B?ckJyZnR3K2gzUUx2QzJtZGd4U0xqaHAyaEhQRGVvSU5UaUlldXNGMlovTVJW?=
 =?utf-8?B?RGY0UGpIcmMvMnNNMWJNZkg4RGN3dnJwMHkvb0c0cWJ4cFBtS3Jkd29JYXla?=
 =?utf-8?B?aEloOEM5N01jSm9HeFZHV3NKMEFSOEN2ZDcyNDdFT3JLano3UlpSaGZBcnIr?=
 =?utf-8?B?V3JDQlpkZ0IyN28rMnliUUZURzFubXUxc2sycFhkbVZqYVVHUFNkTTA0VmRQ?=
 =?utf-8?B?b2pUWWFYVnRuTnJXcEJlQ0xNVUJmSk41blBnU0RkRCtFWGJ1RjhPaXJBZCs0?=
 =?utf-8?B?NzdFd3ZGZHVEVk1TTFNLVDlFYUk0anlRSitnSjRVcVFJaUlGY2RaMitEanda?=
 =?utf-8?B?aVNBOTdlcVRvR2JPMFFoTkZJRnRtWmdKeXNoV3lTYzFLZ1ltZ01nb2dyRUJm?=
 =?utf-8?B?WDIzSE9CVnJSZ25PMEtLNFk2cXc4Wlp0d0FaZlByWCtHVlE5YmdnUFFVakhE?=
 =?utf-8?B?dzhyNkRMZnJkZ0VFeG5wenNEaVpaUUxZTUs5WFZUdGFUTlM0bThUZ2MrcmNG?=
 =?utf-8?B?RXNiRzRxT0NPQkRkYWkveTJ6RjQwU1Z4TkptYnoyRy9YUWxwTUVraUoxeXFv?=
 =?utf-8?B?bWxpYjE3eXpMOFV5OCs5ai9OQzZ1WEF1RGNwejlkTHFzOWEzNmJOaC9oWEl6?=
 =?utf-8?B?MS9BRFNNRjRmUFZKd0k0cUl5TVJNTW5oR2t5VVNoUVNteVlMak9ITkZWb0tN?=
 =?utf-8?B?cGlINDVQTU1uT3MrZE4rQ0xld00rb2tkaUtHUTN6d1hCNHJjTnRraTVzb0xp?=
 =?utf-8?B?ZEtkTmRDVTF3NWxLZDhDQnpsME1rM0M3MktzdjNkODBiOGozaXRzWUZtS3F4?=
 =?utf-8?B?ejF2ajNBL3ZKZzUrdVo2NFp2YzBlVVJ5Sll3WDZuay9qS2pDRldqSWlCby9V?=
 =?utf-8?B?elZQSjZxOTBxVTZBSDJmNkJRSXAwNWlGM2swRnFhRSsycElCYjF5L1A5V1hF?=
 =?utf-8?B?Z0dpcFNDYUF0alI1Zk42L2FlZWhneDFLditidGpPWm05Z20zTWp5MzFLZmtS?=
 =?utf-8?B?UHNLclhMMGdVOEVrR3ZJNkNqanV3cmRreHFMUzlFdVRPMDZxOVRrOEdKQUF4?=
 =?utf-8?B?bDBRZEMwNEJHazVUdkZVVEQwaGhrN1g0cVBFcXJTQXVnR293cmhLU1hwV3hm?=
 =?utf-8?B?YlgvSzVWQXFrWHlzNW9oUTZCck5SYnJiOWFOYmlBaHUvYXlnMmVRc3p0NXFO?=
 =?utf-8?B?OGc2S2JhSnh6UFFnM3JhKytpWktyeTF1ZUoxOHRhY2dqUWg2d3E1UTdiUitj?=
 =?utf-8?B?dktSQ05HMGJnNDdwMWhWTGNLL0duVVB0WVhhWVdjQVlHc0tTNnF2UnR0elRC?=
 =?utf-8?B?Q0tIcWt2SUlJZnhMZlNjZ0w2V1Q5REJrNTUzdzZ6RVZzQ2lQc2syQmFDTzNi?=
 =?utf-8?Q?yMu762TROlWcMlxBwPUQkPCz6?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 ba67d978-a8bf-4431-21c8-08dab634277c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 udfwo2j2L0kUkGGo78kdRh16ERRTKwA6ahabLxoGBnT90KiWFGofDioJlAkMsb63
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5192
X-ServerName: mail-dm6nam12on2083.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:amd.com._nspf.vali.email
 include:%{i}._ip.%{h}._ehlo.%{d}._spf.vali.email include:oktamail.amd.com
 include:_spf.salesforce.com include:mktomail.com ~all
X-Spam: Clean
X-Proofpoint-GUID: RH89Id6drAIQ46XDpS3cjobJwFORBw_c
X-Proofpoint-ORIG-GUID: RH89Id6drAIQ46XDpS3cjobJwFORBw_c
Reporting-Meta:
 AAEjMhSgYz6V/aHTXepoE/6GTVIgx7C4kTaTHr+N11ScovJEgyeFZm6E+0L7gWd/
 Y/qpid2jHDaOppakkgkmNeVQ3mFaftcvh3rRHBB6A56webWRMWVF+EOcolrkrJLl
 qqT2FadpJgS6rgMrVPOx91dqh2jqGT320jiux9EW4RUBBwlQFxsdusHZ4UHMk1rd
 dzJsOdN9Xvi1jf5tgehLMFT75OUdGy095jsPS4E1ub3hJ2oC4gX/mo1Mpbx7Xo5W
 rsvDi1O5D1gydThW7t+/SSlrSQM0uGFImL9L4eW/TqHM/nln580QN3/goiWoYpXf
 gdADT0eVmP/yU26SH6TK5oXn0wHCyOUiZenvGWUjsaj/V7CqSpOt3Pt8EC7K6JyX
 ioQ5kyKEfht6Bd5RPydXBd4nsVeM0hausfj+083gJv7+q3lZvPt9sBNEEKZ8X0fO
 fCqFRMe1wva9xqR6xN6e2UPjBhlqYke4gvixiOYSW78S69yPRvJCGqOAnkwM7Ati
 GKfKS7wOt+2KkCpDlQsu4RwT8MU88MbVvZHqx1imug==

On 2022-10-24 08:19, Yang Yingliang wrote:
> Inject fault while loading module, kset_register() may fail.
> If it fails, the name allocated by kobject_set_name() which
> is called before kset_register() is leaked, because refcount
> of kobject is hold in kset_init().
> 
> As a kset may be embedded in a larger structure which needs
> be freed in release() function or error path in callers, we
> can not call kset_put() in kset_register(), or it will cause
> double free, so just call kfree_const() to free the name and
> set it to NULL.
> 
> With this fix, the callers don't need to care about the name
> freeing and call an extra kset_put() if kset_register() fails.
> 
> Suggested-by: Luben Tuikov <luben.tuikov@amd.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v1 -> v2:
>   Free name inside of kset_register() instead of calling kset_put()
>   in drivers.
> ---
>  lib/kobject.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index a0b2dbfcfa23..3409a89c81e5 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -834,6 +834,9 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
>  /**
>   * kset_register() - Initialize and add a kset.
>   * @k: kset.
> + *
> + * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
> + * which is called before kset_register() in caller need be freed.
>   */

The "need be freed" is confusing here because it is not clear if the user
needs to do this or if it is done by the code. Since it is the latter,
it should read "_is_ freed". Like this (no "NOTE"):

"On error, the kset.kobj.name allocated by kobj_set_name(),
 which must be called before kset_register() is called, is freed
 by this function."

Regards,
Luben

>  int kset_register(struct kset *k)
>  {
> @@ -844,8 +847,11 @@ int kset_register(struct kset *k)
>  
>  	kset_init(k);
>  	err = kobject_add_internal(&k->kobj);
> -	if (err)
> +	if (err) {
> +		kfree_const(k->kobj.name);
> +		k->kobj.name = NULL;
>  		return err;
> +	}
>  	kobject_uevent(&k->kobj, KOBJ_ADD);
>  	return 0;
>  }


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
