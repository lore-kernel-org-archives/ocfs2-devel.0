Return-Path: <SRS0=G199=HA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB4AC433DB
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Jan 2021 18:34:54 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A362760C3D
	for <ocfs2-devel@archiver.kernel.org>; Fri, 29 Jan 2021 18:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A362760C3D
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIYArD027558;
	Fri, 29 Jan 2021 18:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : references :
 from : message-id : date : in-reply-to : mime-version : subject : list-id
 : list-unsubscribe : list-archive : list-post : list-help : list-subscribe
 : content-type : sender; s=corp-2020-01-29;
 bh=QE6NmokhnH+ueGjLACP12j99XBE96lYy8I5zG+LmRFE=;
 b=BwNABrLuaFxG5Q/H4/5gRWIozhOj63B97aGy0SCAcBN2JhNWJm9ztoQkO+lKJUEX3lAO
 BU7vY3MCFGKI1ihKFBD6FZ7Wn5ZUw9UBCbmvoJn8sHdkH90uW1C6mrCQ9sJ+hbKYpIS4
 ZgqmtHrfmuuYyb9AlRXGIhmqoX+FR14rKB8++32rqLUEbEr6jFVl2UazXyf/i38W3Ahc
 tku4UQlR+mELQYQzCr2/VTd5foi6h4e+QW+rE2yRuBPursr9RJkrneA6hsy4SBUV0voD
 ugq6E63ylwGG9PmOWNZg3jYoWQ2UzZ5Jf2AGtC8SRfBDOLZXBiHf23n7CskBmkoEfqIU yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2130.oracle.com with ESMTP id 368b7rarp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Jan 2021 18:34:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TITxEL157786;
	Fri, 29 Jan 2021 18:34:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 36ceuh1ub1-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Fri, 29 Jan 2021 18:34:51 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l5Yba-0004jp-FE; Fri, 29 Jan 2021 10:34:50 -0800
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1l5Yb6-0004iz-WD
	for ocfs2-devel@oss.oracle.com; Fri, 29 Jan 2021 10:34:21 -0800
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10TIVGvS186041
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 18:34:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
	by aserp3030.oracle.com with ESMTP id 368wcsjk82-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 29 Jan 2021 18:34:20 +0000
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=oracle.com; 
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN6PR10MB2910.namprd10.prod.outlook.com (2603:10b6:805:d8::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13;
	Fri, 29 Jan 2021 18:34:18 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::944e:1242:5e95:a93f]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::944e:1242:5e95:a93f%5]) with mapi id 15.20.3784.020;
	Fri, 29 Jan 2021 18:34:18 +0000
To: ocfs2-devel@oss.oracle.com
References: <AM6PR04MB6488440A41759D9FF9A3C5A6CFB99@AM6PR04MB6488.eurprd04.prod.outlook.com>
	<3E55B25E-76CC-4FFE-BF98-0637BCB4D9CC@ORACLE.COM>
	<ce23a917-0cb1-065a-59b1-3e4789fb0d79@suse.com>
From: Wengang Wang <wen.gang.wang@oracle.com>
Message-ID: <e0d299d1-21f1-0738-ff73-7cc3031cd581@oracle.com>
Date: Fri, 29 Jan 2021 10:34:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <ce23a917-0cb1-065a-59b1-3e4789fb0d79@suse.com>
Content-Language: en-US
X-Originating-IP: [71.198.166.82]
X-ClientProxiedBy: BYAPR05CA0086.namprd05.prod.outlook.com
	(2603:10b6:a03:e0::27) To SN6PR10MB2701.namprd10.prod.outlook.com
	(2603:10b6:805:45::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-159-141-7.vpn.oracle.com (71.198.166.82) by
	BYAPR05CA0086.namprd05.prod.outlook.com (2603:10b6:a03:e0::27)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8
	via Frontend Transport; Fri, 29 Jan 2021 18:34:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ca5bb56-3487-4602-4c8b-08d8c4847cbd
X-MS-TrafficTypeDiagnostic: SN6PR10MB2910:
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jYvLj3o9lnzGXK61h7i4IuldvsVPxVDd73+D6GoiZ1a0fZf5jXsNap0mbMKZFaU//B0UUPhVM/jUbAUd30As/dO0Q+sNjnMke4LzHNI+RNDzStki+ns6qUJYsVzvjbputV8xSUXDt5E5F2i3Xjb1jWk3jDvVu4/zuG6NSWteYQvEqXdYpY6oJDvjhIKvGLVvh2aEnhDI1otYMKpoj1NWMqwSdiooUh7KYuwKDErveRClNuV4fU1RSaVJbyFjIDfYuGFRegjPYD3xPR85XUgd8wiJGJQkfeJclPLpsG+v+CEZf3kVrsCa1iuHL5EhmBs2DoNOkGsDg+XoBCp2mrgYrn+h+iqNG6KRD1c6In/LGFKuJvv6H1A6c+j5nYeRYbQ5mXH75ezXKHJB2IaL+eOq+8hH4krlcGxztKkyQ8RzyQPThDkFcQLpOF4IOtmYL/Jqqvmf/zYnVnYnS6bNtFlX34KKiqzSjvGKSMuUqFjGH1yGFxeuo57hDr9UI3IRe9uFk2JGJvaQOsTX+/LSdxSh74eSO3RSt+0PNG/otUEugWN6PXcIPsL7O3fIkZy9uV5e
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OFJrQWE3Z2dSaWgxSzYvOUtkUUJFNXFsdGsxTGduemJCRVg5RWdKOW9meGtY?=
	=?utf-8?B?c0VUZjB1V0J1R3YzazVLNmZGNkl5Zy81MXFOaUY5LzJhQWwrT3JEY2lEbzVS?=
	=?utf-8?B?eTduNWp5ZjVieVdTa1drS090WmE2UFEvaGhBTERhRW5EaEhFaVBpbW9SWjc0?=
	=?utf-8?B?bEZjSjJZNitKMlNHd2lhQmYydmoxVlMrcHlqQm9BeXB5dC85cSs0S3dpNitJ?=
	=?utf-8?B?RjgvM0NZSU9LNjF2Y294N29VUTkvNytFRUhXNHo0MHVSQVQ3M2x3MCtTWFFs?=
	=?utf-8?B?cmZaQi84aDFWdHRzb2JaVGU3dTRYd3JyY1ExOG0wd0FvdVJ1Q0JEWHZ6c0FI?=
	=?utf-8?B?Vmp1YTc4R25rMko0NGRFWUM0ejJPVHJtdzl5eEoxOWZXVzBYVFlOWi8va1Ir?=
	=?utf-8?B?ZHo1NGpRMlpyVlBIenJoRCszWUJQaWc1YlgwaHcxV1VITlduTU95Ni9IN2dv?=
	=?utf-8?B?Q0RjK3pXZFd5dWlCTFU4V3haQ0NWNW01RktqY2p0Y0h2dXhrNU5Yamhneko0?=
	=?utf-8?B?S1ZEcENuRzl1NC9EWm9NR2hoR3h5a29wMUVvTVVEUWVBSUs0eVlSS1o3L01v?=
	=?utf-8?B?M0NoK0tNVGw3Q0Jub2RuQzdCUU45UC9LRnlNRHJ0Z1ZPVkNjd1pwZFhqZ1Nh?=
	=?utf-8?B?V3MvVkMycjRzKzlpemNkRmVROFFRRUxaNDFSbC9HQjFWekFsbVRqdmd4V3d1?=
	=?utf-8?B?VGZLMFVRczNhZnUxQWlpNXdjTFZJTHg2amlzUWF2RUZYYVc4dXRaTmQvck5W?=
	=?utf-8?B?YkhjSjdSa3cydVZjQ1Y5S0ltaHB1NHA4OVljamd2VDFPR1oyN2tzaGRPUmE3?=
	=?utf-8?B?Y0Y0Wk9DTjVtZG5JMnZxWXlkV3pzenRXdFV1NjNkZkwxMXhyeTdXdzY0OGtZ?=
	=?utf-8?B?Qk0yNENsQWFPbGxwb0xQOEcxL05CNmJ1SEcxVzh1Y2EvcnNaVFptKytteklr?=
	=?utf-8?B?RTMwNG4yYW8yRmhGbXE2enBpWVVySGR5Z1JqUTZoa3pKbk5xK0JMaktHU3lJ?=
	=?utf-8?B?U0pCM3N2c3g5YWx0bzlZV2Z5MWZ2eEx4cjYzQnlFQTRSU0xCM09uVVpHcVM5?=
	=?utf-8?B?OGZJeEx3Z2xyaTdJWnRCTFFjUExlNU5SYi81bEhJYlBPd0ZPSlRzNmdQbVhC?=
	=?utf-8?B?RHJSS0ZmazBHZ0tzczJsMjhPRG9zMGpNNk4rMnZYUUpnYUNDa0QzRmtGaWQx?=
	=?utf-8?B?cjBwK3hXYTFqeTJ4QTd3Z1hKMUdVcEdYSDBxcy9pYzA0SnEwK0s1R1kxV3Zp?=
	=?utf-8?B?NlBUa0ZOVDgxa0c1cG1xeFV4d1g2TUkwYU5YWVYxWnpDSHZDcFlVcTVuam5K?=
	=?utf-8?B?UmR2djVZK3lDK3A1cGpYMDF5YVh0dXo2aGYxSFdsUTN0bXFvVkorN2p0NkVM?=
	=?utf-8?B?R0RVK1Z5dVVWWWtLeGdGcCtCWHdHQTBPVEJqdmVva0pkb3EyWHc3eUFnSzMz?=
	=?utf-8?Q?L3pyD5lw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca5bb56-3487-4602-4c8b-08d8c4847cbd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 18:34:18.2341 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TIIP29JbgsNkNL+OhPCBidLeN8b7GnI9fudCqINGEa51KmEUJiCd1rp9QMqrUKeo9I+doUDIYjcwVbqERcFMhVZ0+Di2uxLSh1YKZP/uQjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2910
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission: 
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 71.198.166.82
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating;SFV:SKI;SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN6PR10MB2910.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	mlxscore=0 suspectscore=0
	phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101290091
Subject: Re: [Ocfs2-devel] About the status of reflink-tools
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1325759243352856491=="
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290091

--===============1325759243352856491==
Content-Type: multipart/alternative;
	boundary="------------E73456916CB6B8559C1ADDED"
Content-Language: en-US

--------------E73456916CB6B8559C1ADDED
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	10TIVGvS186041


On 1/28/21 11:46 PM, Gang He wrote:
> Hi Herbert,
>
>
> On 2021/1/29 15:33, Herbert Van Den Bergh wrote:
>> Hi Gang,
>>
>> The reflink functionality has been merged into the coreutils package/p=
roject. The cp command now has a =E2=80=94reflink option. Check it out. I=
f this isn=E2=80=99t what you=E2=80=99re looking for, then please elabora=
te.
> For the other tools, e.g. shared-du, shared-filefrag, where do you
> download the related source code? still coreutils? that means this part
> code is included/maintained by coreutils project?
>
    $ rpm -qi reflink
    Name=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : reflink
    Version=C2=A0=C2=A0=C2=A0=C2=A0 : 0.1.0
    Release=C2=A0=C2=A0=C2=A0=C2=A0 : 3.el7
    Architecture: x86_64
    Install Date: Mon 21 Sep 2020 05:57:56 PM GMT
    Group=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : System Environment/Kernel
    Size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 55003
    License=C2=A0=C2=A0=C2=A0=C2=A0 : GPL
    Signature=C2=A0=C2=A0 : RSA/SHA256, Sun 04 May 2014 06:33:00 AM GMT, =
Key ID
    72f97b74ec551f03
    Source RPM=C2=A0 : reflink-0.1.0-3.el7.src.rpm
    Build Date=C2=A0 : Sun 04 May 2014 06:32:55 AM GMT
    Build Host=C2=A0 : ca-build56.us.oracle.com
    Relocations : (not relocatable)
    Packager=C2=A0=C2=A0=C2=A0 : nobody <nobody@oracle.com>
    Vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : Oracle
    URL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : http://oss.orac=
le.com/git/?p=3Djlbec/reflink.git;a=3Dsummary
    Summary=C2=A0=C2=A0=C2=A0=C2=A0 : Tool to create reflinks on ocfs2/bt=
rfs.
    Description :

    The reflink tool creates a reflink on an ocfs2 or a btrfs filesystem.

Maybe the URL part gives you some idea.

Cheers,
Wengang

> Thanks
> Gang
>
>> Thanks,
>> Herbert.
>>
>>> On Jan 28, 2021, at 6:59 PM, Gang He <GHe@suse.com> wrote:
>>>
>>> Hi Guys,
>>>
>>> You know, ocfs2 reflink related utilities were maintained by a sepera=
ted project reflink-tools,
>>> What is this project's status? e.g. who is maintaining it, where can =
we download the latest source code?
>>>
>>>
>>> Thanks
>>> Gang
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel@oss.oracle.com
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

--------------E73456916CB6B8559C1ADDED
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp3030.oracle.com id
	10TIVGvS186041

<html><head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dutf-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class=3D"moz-cite-prefix">On 1/28/21 11:46 PM, Gang He wrote:<br=
>
    </div>
    <blockquote type=3D"cite" cite=3D"mid:ce23a917-0cb1-065a-59b1-3e4789f=
b0d79@suse.com">
      <pre class=3D"moz-quote-pre" wrap=3D"">Hi Herbert,


On 2021/1/29 15:33, Herbert Van Den Bergh wrote:
</pre>
      <blockquote type=3D"cite">
        <pre class=3D"moz-quote-pre" wrap=3D"">Hi Gang,

The reflink functionality has been merged into the coreutils package/proj=
ect. The cp command now has a =E2=80=94reflink option. Check it out. If t=
his isn=E2=80=99t what you=E2=80=99re looking for, then please elaborate.
</pre>
      </blockquote>
      <pre class=3D"moz-quote-pre" wrap=3D"">For the other tools, e.g. sh=
ared-du, shared-filefrag, where do you=20
download the related source code? still coreutils? that means this part=20
code is included/maintained by coreutils project?

</pre>
    </blockquote>
    <blockquote><font color=3D"#a25944">$ rpm -qi reflink <br>
        Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : reflink<br>
        Version&nbsp;&nbsp;&nbsp;&nbsp; : 0.1.0<br>
        Release&nbsp;&nbsp;&nbsp;&nbsp; : 3.el7<br>
        Architecture: x86_64<br>
        Install Date: Mon 21 Sep 2020 05:57:56 PM GMT<br>
        Group&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : System Environment/Ke=
rnel<br>
        Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 55003<br>
        License&nbsp;&nbsp;&nbsp;&nbsp; : GPL<br>
        Signature&nbsp;&nbsp; : RSA/SHA256, Sun 04 May 2014 06:33:00 AM G=
MT, Key
        ID 72f97b74ec551f03<br>
        Source RPM&nbsp; : reflink-0.1.0-3.el7.src.rpm<br>
        Build Date&nbsp; : Sun 04 May 2014 06:32:55 AM GMT<br>
        Build Host&nbsp; : ca-build56.us.oracle.com<br>
        Relocations : (not relocatable)<br>
        Packager&nbsp;&nbsp;&nbsp; : nobody <a class=3D"moz-txt-link-rfc2=
396E" href=3D"mailto:nobody@oracle.com">&lt;nobody@oracle.com&gt;</a><br>
        Vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : Oracle<br>
        URL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :
        <a class=3D"moz-txt-link-freetext" href=3D"http://oss.oracle.com/=
git/?p=3Djlbec/reflink.git;a=3Dsummary">http://oss.oracle.com/git/?p=3Djl=
bec/reflink.git;a=3Dsummary</a><br>
        Summary&nbsp;&nbsp;&nbsp;&nbsp; : Tool to create reflinks on ocfs=
2/btrfs.<br>
        Description :<br>
      </font>
      <p><font color=3D"#a25944">The reflink tool creates a reflink on an
          ocfs2 or a btrfs filesystem.</font></p>
    </blockquote>
    <p>Maybe the URL part gives you some idea.</p>
    <p>Cheers,<br>
      Wengang<br>
    </p>
    <blockquote type=3D"cite" cite=3D"mid:ce23a917-0cb1-065a-59b1-3e4789f=
b0d79@suse.com">
      <pre class=3D"moz-quote-pre" wrap=3D"">
Thanks
Gang

</pre>
      <blockquote type=3D"cite">
        <pre class=3D"moz-quote-pre" wrap=3D"">
Thanks,
Herbert.

</pre>
        <blockquote type=3D"cite">
          <pre class=3D"moz-quote-pre" wrap=3D"">On Jan 28, 2021, at 6:59=
 PM, Gang He <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:GHe@suse.c=
om">&lt;GHe@suse.com&gt;</a> wrote:

Hi Guys,

You know, ocfs2 reflink related utilities were maintained by a seperated =
project reflink-tools,
What is this project's status? e.g. who is maintaining it, where can we d=
ownload the latest source code?


Thanks
Gang

_______________________________________________
Ocfs2-devel mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:Ocfs2-devel@oss.orac=
le.com">Ocfs2-devel@oss.oracle.com</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://oss.oracle.com/mailman=
/listinfo/ocfs2-devel">https://oss.oracle.com/mailman/listinfo/ocfs2-deve=
l</a>
</pre>
        </blockquote>
        <pre class=3D"moz-quote-pre" wrap=3D"">
</pre>
      </blockquote>
      <pre class=3D"moz-quote-pre" wrap=3D"">

_______________________________________________
Ocfs2-devel mailing list
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:Ocfs2-devel@oss.orac=
le.com">Ocfs2-devel@oss.oracle.com</a>
<a class=3D"moz-txt-link-freetext" href=3D"https://oss.oracle.com/mailman=
/listinfo/ocfs2-devel">https://oss.oracle.com/mailman/listinfo/ocfs2-deve=
l</a></pre>
    </blockquote>
  </body>
</html>

--------------E73456916CB6B8559C1ADDED--


--===============1325759243352856491==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
--===============1325759243352856491==--

