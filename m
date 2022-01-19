Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D11DC433F5
	for <ocfs2-devel@archiver.kernel.org>; Wed, 19 Jan 2022 11:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Qjcn/u1V5ARrJZ0lWs2twUAS+w+q3ShYuSjJ3wvbKB0=;
 b=EpDGO0bsfOz8ys3oGD1Rv8JycS01Ru1g6YAg0lKBvoAJVjbPqcnztTwVFPNchuREEt3X+AAmF2yV
   qVlYOGxWNjV4v5L5JJST4KSaIhAEp8AlQM4UkBqYiX96O4+gMg+96oupnF4ZkOLbiGxNs3ej2jLc
   xYi2E7fGdy9uISvxF8SQYQN0+aFnV1OFqUrUtBsQBothYfXj+hqnFYa2ZYUy8uhbLIpsgjbi7aDE
   o6LVTdmhW5OcacZYVD98dqoVOknvMhuB0B42h3RXAb3JGy8L570t/IRocvx3rJlNz79VH2zncUXV
   UPKcd2iwK9/4xUHWdCrM+4PB//QRl2aGUDcKfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Qjcn/u1V5ARrJZ0lWs2twUAS+w+q3ShYuSjJ3wvbKB0=;
 b=camxWzMrT4BlO426NTzbAOrJO8CkQcO3guNz5Si8sF2pWna8689tK0kiQJfGTUz2N2rXNNdmH8/M
   bEnvzwYUFbean6hwW22H6QGjrAoMKeyzhhNGJObHbHsbZpQ/Xjn45bpgeakeARm/fsfXBCArCeUv
   e/lCym9jAWgJtDir6ujChe8HKonBFkpz5GECr8jFf/32E8jJ8mhQInzP40rJCncQqKR3wAEqCOBT
   v0tLokI9vIpiEost7JHudHGew32GIdQqmrMOcoaig2mIw1QYXdii4JVSxuy7cToeTV+f7T2NdjZa
   2xREGASNAtwEmdoBBOyYzjVqOT2horTG9GMc0w==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R5Y00LAQFXWPB30@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 19 Jan 2022 11:29:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date :
 from : to : subject : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=ypGbHb838cPwY8Dlac9Ltk88mxR7XpnMj5HAbaNP/dw=;
 b=tlN50jVfAOVbesZSsdafNBW5z7nHygs53BfMU/0GdvHS08E4QTaf751J212tWEkxvZhW
 2trQaioTZAY5Ice1eDiBTVJEsV4vKTMSZDEWpQZwKhcPVpWdDSjlHgPuUsKQ9XT07wQR
 vTD/VJMCzy+q2GwN+G6XlKCVLLzqXA7nMYZliIN3KkCxZJG/TZMy5XodCZ7XOBcokVYh
 XoHuJR3zzbOs4amL013mXWLsA6nIaRMIQs+sNdmiWoM+iM1nhrucizuy7yG2plGjuywV
 u7sSIPv1cIU526smuupnqZESYbzGEQ3WHZzyI6M6PMBIuTozcZKLkDYcgwbb3rrEbN3j 9w==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=dan.carpenter@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsM6Md1lgs2le6n285KH0lrInU7yqOlV2G4HuhfO0OVVUDXYuycSS+L5+GxqYryHkorONIFBKtlJfFPF2NbyO9u24hjWdH9/n3VDW/+Rttj0ikHnFNaFhqzJCyZ+QF336s1ww3IG7+kZoUimczWVTOfxOR5Xu2GLTkeLR79TAqHD5WaG30MbVONGnXxtp/rwegqRv14OmZCc45c0EG5008aqxuLqcuTuFRUNRxgpI6jlha+6wS5ZYv3E0hx6pIF1Xs7dzs626Oi8WYY5gogyQFbcFRa5o9Wa7wmv7Xc3Sn98qrvRENH1GUYQMk1leUe47FK/Fv9z7Jq2noQOulxFaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypGbHb838cPwY8Dlac9Ltk88mxR7XpnMj5HAbaNP/dw=;
 b=nvFhYnKra5t5SVufcy3Ybd5eCeeMBJIlNFzSYqgNPjRGUv/RKKb69P9DKylHmNOOc7ey1X3LbdqkX/YyLn5k2Tnd2YiKu+F18WuM0Im5ramz7az/hpYgxiguZJ+f6mksn2V6DRBYSk8bOPUUmwX2iYFD0iAhqn5eZWGwyB9czLBWFZVzQ893jKjiHFdUO0hcp25WQ9S2fJhPT0/JOekERbC8pPpwIb2aESdgBNImX9oGSgNBlFVqE7UvMTFY20OhcvFwHo+cL2hv3U5KQA2ubYxwK8aCxys1RS8pMFdBUbf/+7SBTh5isiAaR8L5EsAnkfWIc0eKuCNnfh4Teo110w==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypGbHb838cPwY8Dlac9Ltk88mxR7XpnMj5HAbaNP/dw=;
 b=yekBPFydW3TwQgSs2nY5ytgfptrRh9WGPuF1Gt2xJWw+hl6DcoGJfSyxFaQQX+m8A12DfoiWTCQucYc9vmPU9oY2B5xuy2ReKr7vzo7FPeMXo0r2ROFGN+pMjCks/gufsetYM2PFIWnRFVNifph9xuupLhu8DGzBhkaUcvapYpc=
Date: Wed, 19 Jan 2022 14:29:36 +0300
To: ocfs2-devel@oss.oracle.com
Message-id: <20220119112936.GA8111@kili>
Content-disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:MWHPR1001MB2365.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 11:29:46.5344 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231
 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=924
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190064
Subject: [Ocfs2-devel] [bug report] ocfs2/cluster: Pin/unpin o2hb regions
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
From: Dan Carpenter via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Dan Carpenter <dan.carpenter@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1132b006-47fd-4254-4762-08d9db3eff19
X-MS-TrafficTypeDiagnostic: CO1PR10MB4545:EE_
X-Oracle-Tenancy: 1
X-MS-Oob-TLC-OOBClassifiers: OLM:494;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 KwtCH90tlPPGE6S5coB7mLTmBVe7nLlHdXXQgPeFX8s0H1bnx3ibLJJP+ycJUmNkZLjisu/A0gXhPG9s7c9wHxWuGuPhEXb5VrmPx1+s99RFkO6wGNYIAnaAioB8uOLl+9sjbHsJsXtR3BkFlxVieqg5c6zmTrF4z2KZjH88lsRSNCdb2vGcuu25fFeB2cfZDIguVs/tzyn+B2b3DI1M0R2m3lV93yZ+JmhXIkBDjnV3JqEGb5GiKb2ej9MB+F7Xa0205h2ts9B1dvGc/4iz5qVvFm6xa4XupZ6KrFa7uCkMIiFto5ZmtvEPHqWlaDbpQxidZLofriGjfMIA8c6xSXXxaTGubZ6kFRbZZoMN7AUqCG+axLmO8T8wvUCItpSMyc+b96mTMUPo4ocQucF87+2m56gYxVPXURSM9QJU46INGI/pdTpDIhhqAwoF7dpAOl1N0AlZ1COdSAP20O1utRwrwu1dIJTC5ah/jKrPo0FkhQq4V7NFRyQfucwYT00EfoVDDE5/BPCcL7BIRqCI7PNR3uuNaM2Xcf0DwRkWRsKSt353JR5FnElZp/AXnlcCsRBNWlHTPCvAtM84bAxM1S4t39CFCPh96rHJBn8md08=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 1132b006-47fd-4254-4762-08d9db3eff19
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 gVCLXKZd93y2bXoW4boixIVdRjuMqRZ8udQZWGyPqnlkiHKbfnc3+1i4OmGLHnT2jdCNvsqQipSWfvUVae9C9Pr+ZJd0Oy3jGMPn9q4pShY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4545
X-MS-Exchange-CrossPremises-AuthSource:
 MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Dan Carpenter <dan.carpenter@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 102.222.70.114
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: CO1PR10MB4545.namprd10.prod.outlook.com
X-Proofpoint-GUID: 5tIbJvkv_Q40nmz4i29H11ZA1EFwED2s
X-Proofpoint-ORIG-GUID: 5tIbJvkv_Q40nmz4i29H11ZA1EFwED2s
Reporting-Meta:
 AAENGRjDsDlZkxzGS+t8Uj4g7Dspuu35T24mC1cMjFFPrnbjSxBK95JXB/t702c7
 q/e/hGyANGP9xnHDshN7/R9SFbDklRTjwaPTuxyNRCm7OAZzr6eHWXHqTlllVyXT
 iX5aXmi3ZEiIvp7vz3vETBA8P1ZtEnC+aKO9ZNJThrHIN3SNGuJYurXDqcmQjvkx
 Z60BFxpmJJ+66wsHb0E9RceGUy4Wbhda220EQpYF3hid+4oucA5XXNwt687gBXf4
 /AdIt44p8tz3tVOYH9xXnRi74KHfUQAZdxynrNtyCaAxuudmbzfIuBuUQcrD/OUA
 8zSWoHDF6PC5q00pwnBAMgJ3VKRRnGr1SRZpqKZYMSI+pgG1bY+epEC/psnPke6U
 6b0+TchhdNgw7nfBlMLppBS9CvFxb1p6XsUym+YGeOkop5hIrs3v5JDG4VLLVoyH
 LyFrNPOi0DdO/CUXmgJwGUTobq8ZS2W/yu0avWthUy2tAlt7nOZrJIZNf+RG7H9g
 znIkX9yqWnV6KsBsuOYBDl53TDunGNsMlAhT68iky/Y=

Hello OCFS2 developers,

The patch 58a3158a5d17: "ocfs2/cluster: Pin/unpin o2hb regions" from
Dec 14, 2010, leads to the following Smatch static checker warning:

	./include/linux/fs.h:777 inode_lock()
	warn: sleeping in atomic context

The call tree is:

o2hb_heartbeat_group_drop_item() <- disables preempt
o2hb_region_inc_user() <- disables preempt
-> o2hb_region_pin()
   -> o2nm_depend_item()
      -> configfs_depend_item()
         -> inode_lock()

fs/ocfs2/cluster/heartbeat.c
  2265        static int o2hb_region_pin(const char *region_uuid)
  2266        {
  2267                int ret = 0, found = 0;
  2268                struct o2hb_region *reg;
  2269                char *uuid;
  2270
  2271                assert_spin_locked(&o2hb_live_lock);
                      ^^^^^^^^^^^^^^^^^^

This code is holding a spin lock.

  2272
  2273                list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
  2274                        if (reg->hr_item_dropped)
  2275                                continue;
  2276
  2277                        uuid = config_item_name(&reg->hr_item);
  2278
  2279                        /* local heartbeat */
  2280                        if (region_uuid) {
  2281                                if (strcmp(region_uuid, uuid))
  2282                                        continue;
  2283                                found = 1;
  2284                        }
  2285
  2286                        if (reg->hr_item_pinned || reg->hr_item_dropped)
  2287                                goto skip_pin;
  2288
  2289                        /* Ignore ENOENT only for local hb (userdlm domain) */
  2290                        ret = o2nm_depend_item(&reg->hr_item);
                                    ^^^^^^^^^^^^^^^^
The o2nm_depend_item() fucntion cannot succeed without taking a mutex.

  2291                        if (!ret) {
  2292                                mlog(ML_CLUSTER, "Pin region %s\n", uuid);
  2293                                reg->hr_item_pinned = 1;
  2294                        } else {
  2295                                if (ret == -ENOENT && found)
  2296                                        ret = 0;
  2297                                else {
  2298                                        mlog(ML_ERROR, "Pin region %s fails with %d\n",
  2299                                             uuid, ret);
  2300                                        break;
  2301                                }
  2302                        }
  2303        skip_pin:
  2304                        if (found)
  2305                                break;
  2306                }
  2307
  2308                return ret;
  2309        }

regards,
dan carpenter

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
