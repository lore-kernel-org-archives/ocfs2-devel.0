Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6CDC43334
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 10:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vlOQCRPCWPT2otCVOfUhsn+YtrSo3mQqfF2AnDlfQqY=;
 b=vGIm/5NClc/TgzKDfsOqT4dcrCNwAVKBZimDlQAby9LqJPLL+yYRtxx2jsqSAX5go+yXY03vv6JE
   gdC1M1Yd+oQHOLk5fSwP856p1NxL6AKBT5UAmjt9w7i9jv7bsRvdQd/WI9qkACOcUM6isaiOF1Yw
   AtNzq2EQu4q7cUd1a7KTMxWLdleMDX3Nz55ehgi4nCTb0eh4nRb1i8Z5rQLHy+Xbko8nqtaEbVv1
   LPoW6+MdP3PweikEb8AN5JGiBzS+4FSr/jyQVev9x8LrPPamVF7M3DVzyT9VQIGQsN4hBgk+1UF0
   Rw7GtisfS5u0tcvkyb2pZgpRHRTH9v0R7T69kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=vlOQCRPCWPT2otCVOfUhsn+YtrSo3mQqfF2AnDlfQqY=;
 b=CKAp1dffs1lOc2dC5oXG+dqdKUXpd7j/r7K+cWr6LFSKZ4ofXbmEcNmUURMth/Uy2GgbLFx0y0sF
   HPsk9abOBQY2AsUyMTD7ScYZ+5aaCFGBWqAZ7Ayn9/ueYHEnTPKR84dnPBsiIH+K+4XsmBXJhdf7
   /0QRuEnNwMlWxbzpwMVCW7cHEAezDcG/vZnK812+VN3ockyBRB8K9LOTwUHuJ9sinpFV62lM1WvZ
   b/NFcXAQoUix2pRazC5/qLBWcy3fCZvtS0zH0GE0GyXsHjvw7Pn92mnGHrLSRdzrxjD6ly/Ut7Gx
   yFjXxQjrXMFWHqu2oIZmlf/XIMblhFV9+q1BGw==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD5008H8NDBXL90@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 10:48:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com;
 s=mimecast20200619; t=1654685311;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bLjNEN6tomxWy7PufX6ZRSmuZrIsEfZKO3SkBxeG5+A=;
 b=E8KnwXDXWFf9S0doY2b4XMEr4DetTmA9O7QalJ5ej9dRj4WmMJ00EXRftm+RW37POinhuG
 OBdnfLmR258dM9evQJXyTjoaAq20aKRsw+GWactsfuE1EQlVqDOfma7rfV6xJFPQXOaTDU
 YJMbF0Pw+n8/MIqaiOt6yGQmA5IlQzk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTuvrePjXuh7sHoXxfRXzaX95OoUPq/w4ehOAj6k3dUJqkML1j9W1gQ5WE3DVM5kyhhY3Mqfn+9K/Atvg2TTgj4OMiipJf1jPsZw+jTH8LqwhaaEmlp+wXOJzRS094BIaWj36f0zk26x/QpX4haVH9BjgzCidjpETl2FfAq+T8rohsPzPwovUnuGREbEoY4dElw+9HgV2cXYRc+K6s9j3Y0208q1FR0QEuDAJtB4pEo6lTZmJm1MNw3xvtqq0OAYK16j/FEqo1zvk4t2BzUUL5FaRC4KGl47quVpuFIS5vLwoF12SF9NUdGfQrwEB2eUrPE+DXS7ucbwpBiybHRHgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=55M5t3l2SUEIQF3sedPkiSfMf+O+DFypXeXifOfSQw8=;
 b=IfghYNWjZb7auKBO98h1Dv/iWZhUxIvV/wIuIo9veZ3zV3HkvetYMjKUigZCQfkTT4S6fDeS6kFPHAHEqe+vlrkSON7RSQISwh2eemEi4ZA1GGvOsckmvpkVlvYpaDxx1ua2965/1RlfImVYuM6Jkzn28pJvjKpx/jQlcX6I+Y+2OHxAszUlakdqsiQQu3tCcvbpbhywO1/og+llO4sRKRLbJlURGAXFXLRKImoiY/Pl0GHKYK7fBhGkr4pWRJZRdsOE6GlqEdFIopXLIl3V9ISageGNvuqLcpC+VHMXA155Wqf2kzhRXoUuBHVNUj0Rm+LVmU8f2tAPHcttQv3yrA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com; dkim=pass
 header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysuse.onmicrosoft.com;
 s=selector1-mysuse-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=55M5t3l2SUEIQF3sedPkiSfMf+O+DFypXeXifOfSQw8=;
 b=B63qt87ADHYzzeMRZ5WRkJNHbcgI4VoK5BBimAmODFe9bBq+uv3zND9ljeP59WjNSHfDGdR3OiobvCR+Zlg9XxP2RFsop2mIvDtszSVrK2gPdCmVXrV9aBFs0Rpe1/7hNzOfI4C3kA4YPLnfKocrcWCL4JMQMwblzLWye3c9jlcyU9IKZ9Gz+AeWtUdg1x/sgZ+ezlF4h+jXcKIxbqhLY4qAHNhQRy9wC0w61Wsl+nXFgOpi0iK6sDE6xXuQy2HUy2MIA/AtrcJkXb6iOa/B0kXmUDVrdI1q+hfvyl/LXPn6jVdjhYEiSuiru6hUGf9Nmq4A1MNhLHMG3IZ+wVePzA==
To: ocfs2-devel@oss.oracle.com, joseph.qi@linux.alibaba.com
Date: Wed,  8 Jun 2022 18:48:08 +0800
Message-id: <20220608104808.18130-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20220608104808.18130-1-heming.zhao@suse.com>
References: <20220608104808.18130-1-heming.zhao@suse.com>
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(36756003)(66556008)(86362001)(30864003)(5660300002)(316002)(26005)(44832011)(6512007)(4326008)(8936002)(2906002)(8676002)(1076003)(66946007)(6506007)(66476007)(83380400001)(2616005)(6666004)(508600001)(6486002)(966005)(186003)(38100700002); DIR:OUT;
 SFP:1101;
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 10:48:29.1600 (UTC)
X-Source-IP: 194.104.109.102
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10371
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 priorityscore=173
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=204 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080046
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
	same slot issue
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
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Heming Zhao <heming.zhao@suse.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: OwEk-Rh5NoSOzGlLIakAmQ-1
X-ClientProxiedBy: SG2PR04CA0216.apcprd04.prod.outlook.com
 (2603:1096:4:187::18) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74f256ab-be88-4414-6a25-08da493c6c43
X-MS-TrafficTypeDiagnostic: AM6PR04MB6327:EE_
X-Microsoft-Antispam-PRVS:
 <AM6PR04MB6327701DB090253A8AFEBB4397A49@AM6PR04MB6327.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 VHX75oKH1Rf9eGg9KHaUNHV28YeQqdj7Yb0wyJq3SrUy8Rau/EOfrc2lmSj7f7uk62oM1F3nAKOMrG4GX0jmcxfoxZhlMd2qTC6CB0A3xa0leSjXjviY6SyPGE9WEdppjGKfeVcsUrO7lX6VAieqcnddz5YCaG3k36ZFmFbNffIHEktK3KpT5XhQADWr3unTUFCynqP0LKl9OrJT2wXPar7ca0uEzK1MMyLfdE7kpyXExqFyBYH0yhWnx1hGmGDqTZBeYv65DEuTpVOtir7wpHtXxgSzDa5V5HyJduee6E58wFyNP18U0mPK3WKrDxWdN5D0RQVlENXrUruwYm1mCLPob5e1cMrDwRDNNXpotE7BgRpZvguunbBGxA1bWvu2j0teiZsl9Xyzd/zLqNIWHJH/giudoWr71JPJlh77DmWZ4CSgdGb7evQSm4bPLGCVnCuEhcXSC8j9resscI5tDz1bhOh0qoKblvcJ23N4vEyTAGKgs3zOs9ZTmRf4dfUsXmi2BOoI0G5wY0zo9BRB+zGZArUbE1ZOBS3nnRdmjSuuxYuytE7V+N2GpsAlwuX2xROTXdXJhaeVTJmImhYze9V0QI6Cx180WMkQOyWfeviZdg6WGTcT6uR77qpUUfwiHJ352Asnih4iS6AbY/ZAov/SNGYeb+u2HGC9PZEyDoWafBurWR7VV6rk4tpkK6YuRfgqE9N1DGAMXjTI4SkhJjx0fulR3NCDKD+b9jf9Am4=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?DsFQuwHTDSV0EOJKCG8my3he4VK10EBwjUiuksxsW/1+cls/37LJmBBGIM/Y?=
 =?us-ascii?Q?4SJYOhUiw16wHVVQakfLobkUrbbMqLdZPR32jy8XHVtW8cbD81GUyME4dFsd?=
 =?us-ascii?Q?AFPcYgHdrioXnf9ngyOSeYfIgTMYPKs3RDETc7nwAIJBgkQJhRYP7o7vEtj1?=
 =?us-ascii?Q?QIu+ihaaBi19xzRMSfBr6R7m7eQW7+yMOznN4jSewrPLFd+x32pxyGrpXvRW?=
 =?us-ascii?Q?WOsUqv9htLyMaJOz7Ej+RSPjDMrOop2RcZJ2U5WIe7pqBueSNadbj10zpl2F?=
 =?us-ascii?Q?RDG+4W/DSLp2ta/ILUvy/WqAe59HkMJ48Z6d8rdOzR93qj4NegtV3BoDoH9u?=
 =?us-ascii?Q?kWSvgQRou4jfid9IutsfxpYGseXpufhjvPlPnJyr60etvApfy4KSxsBP62bP?=
 =?us-ascii?Q?txWbA3virwFc76jZPBcw2X7AJM8L7bmJx/fjPC1dm6aVbVfIsGOINZL63GwI?=
 =?us-ascii?Q?wFJMnQPOVAWejisYasIG63LkugNNzPVD4h+ZfJB6SJddLm+JEXl+JzU+wfSa?=
 =?us-ascii?Q?cKiYaAVzn1b0CBlFaNnzph9Qj1jTxgMA6OIXZdYwdMPjKAXP0nLcSZFri+vi?=
 =?us-ascii?Q?9IAUIS0eDNqtKpxWiz3jW5HnE9eCiO3nQHxK1iK9cmtkNq+900EghjjcJ/8v?=
 =?us-ascii?Q?8NOeIVqveApl+uX4UKvtavHVttOYa0me1xQ7d89c0KiN3PJhQKwFSA7VertA?=
 =?us-ascii?Q?JWeXzJ84PVgx+F11jrn5/0EDYnHXZMD1gpw7WIqS5QFgupavHVJbI/vHL3wD?=
 =?us-ascii?Q?PzdWyAhnbqOd2ap/nPs+6hwy6uphcW7rwlZ0pI9CLjWLDDw40ErgguUCufEX?=
 =?us-ascii?Q?SIv7Glu+WpUACyWyaqfKpYvUfdhPMdaVwNCWDZ5miJE6/KXM26YdJZYUiSAj?=
 =?us-ascii?Q?nSiOQMozo7CgUPXG0qEvbKCzaXmZ7v1X0xYHdgF/pehW6gBowEO01bgNQIx0?=
 =?us-ascii?Q?+4M9oeXeqmqJxg7v70ifoZypz/fLV6+G8i4N8FIBeGyeiAA1wzAmFDyvDZzq?=
 =?us-ascii?Q?0lKSv+6YtUThBfmUqnnpVGjsdTwBPNtugNTFC2QfvgK5TxRXMc7NHqJdlhG8?=
 =?us-ascii?Q?0WeCiJFy9H2DS1k2yeUFljUtX5NwroQUhIBtaVhqXt0/4F64z0CHdfJOHhZT?=
 =?us-ascii?Q?bw0Uz1zqEZ5zLAYJAu9x+1ASb0hEYGftDuXQRkC+7dJZ7d7EiljDO6pfRqD4?=
 =?us-ascii?Q?5WukJijruPyTxjxYT1BDWXqiDwbIN1PwI8BNCZHzyjLY3/Dm4r0UWq8gKNST?=
 =?us-ascii?Q?dB5JIsKQx91Muf9xl3e3q5tXU/Wb9sV0RftBBbuxZrVjnbVogjjXRQN0vO3U?=
 =?us-ascii?Q?cac0fBPPRXISEnZ/DRYfSudSRBw5Ro80Bwgc9P+1fw/NJpxjmHDEmHwVoki4?=
 =?us-ascii?Q?GL5yS8+ClOo9Rwl+zauRgm9DQJlzu67MEYIzwCNaIPgIYhLOAWal7L2Y1FqL?=
 =?us-ascii?Q?VAvlEa6nFltOTA8ISEYZOu4ZqNy9ozdsJc5VhOaase1wAWUqeFTfrcx01Pdn?=
 =?us-ascii?Q?dX/TlnfKMz0yPK3RClrjiOOMlmerW8Wyc0vl066TUjg6XMwJAwKkgSkVwsOM?=
 =?us-ascii?Q?NN3BFkxCqeREYVgAQqVD6jlQk7JHVDabQrVZxfJuuGCkaVtR4/BXXmVbNSYO?=
 =?us-ascii?Q?dbjHwHRZhRBLyfB0chRJ/6Nlirn6E8QPWNaghMDellDCp7F2obkBqijcO4Xb?=
 =?us-ascii?Q?ClS6xlyZUDde2iDaZmc/zm+IB4ohbt9sJYw7ndDemXaMHv7KEkkTksbVgakS?=
 =?us-ascii?Q?Y53/9wYEKw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 74f256ab-be88-4414-6a25-08da493c6c43
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 eQB/cTj0GTA+A2R0K3kMH4IvjAS2r3mq6mILPpTib2VRjgOkVpWwu+hF38dpE8WBW4IB8NJl+M9rteKcOdWLBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6327
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
 include:de._netblocks.mimecast.com include:amazonses.com
 include:spf.protection.outlook.com include:_spf.qemailserver.com
 include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-GUID: 1C0z2ovQ76gXucJw_81LsUjOFazXQagA
X-Proofpoint-ORIG-GUID: 1C0z2ovQ76gXucJw_81LsUjOFazXQagA
Reporting-Meta:
 AAGv9v0YWXXb+XCjIPEMYR47MlkWjLoysqg+C/zHhUflGnCy6djdx8hqeptQNqCC
 fFuFoV4oEJiCDYuOQ5Aa0LR/o4oAQfPbVHIg1LImCknLbZSKYLb3euHv4TG88Lwy
 FppDxGlZGWH6lAlVoaKEhs03ruFsok19jEB+9H3hBaQ4Br+6lN/aIH5AK9bnRL18
 bhM9J9UV/S3Y3lG+D6xxlxjOrCxZh1FGyTfUMDnjSPnAZFY+KY/0ETkq5Q0aH6Ky
 Gh2hmSUh1EzUksC69Utt3NnYH1AKgXC3whfUNK3IsWqy1i50cYVkeDgmS+iX02q5
 mKjqs1RLtyiTVsQ84GLXzu+5Hy+cnEciwmaRcWUzRKKRqxnaYbxQnO7tJfLFWXk+
 0Py3yDyXl4E07vfm3aFa3gtcoFA6Gq58gLA4sTAreppcTHnXeBFKv/VH4MFpVn6b
 ilsuiqnxfhyOTQKgeQbEiaM/0NvCpptHPRr4dOEmiMxOU5/BEQr8Rox32s26V1ps
 ljmeXTtYKtLhK7Zv4MPcwbt5yMtA7XrDhmU2CICAhn4=

Below commit log copied from Junxiao's patch:
https://oss.oracle.com/pipermail/ocfs2-devel/2022-June/000107.html

Junxiao planed to revert commit 912f655d78c5("ocfs2: mount shared volume
without ha stack"), but maintainer & I preferred to keep and fix this bug.

-------------------------- snip  --------------------------
This commit introduced a regression that can cause mount hung.
The changes in __ocfs2_find_empty_slot causes that any node with
none-zero node number can grab the slot that was already taken by
node 0, so node 1 will access the same journal with node 0, when it
try to grab journal cluster lock, it will hung because it was already
acquired by node 0.
It's very easy to reproduce this, in one cluster, mount node 0 first,
then node 1, you will see the following call trace from node 1.

[13148.735424] INFO: task mount.ocfs2:53045 blocked for more than 122 seconds.
[13148.739691]       Not tainted 5.15.0-2148.0.4.el8uek.mountracev2.x86_64 #2
[13148.742560] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[13148.745846] task:mount.ocfs2     state:D stack:    0 pid:53045 ppid: 53044 flags:0x00004000
[13148.749354] Call Trace:
[13148.750718]  <TASK>
[13148.752019]  ? usleep_range+0x90/0x89
[13148.753882]  __schedule+0x210/0x567
[13148.755684]  schedule+0x44/0xa8
[13148.757270]  schedule_timeout+0x106/0x13c
[13148.759273]  ? __prepare_to_swait+0x53/0x78
[13148.761218]  __wait_for_common+0xae/0x163
[13148.763144]  __ocfs2_cluster_lock.constprop.0+0x1d6/0x870 [ocfs2]
[13148.765780]  ? ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
[13148.768312]  ocfs2_inode_lock_full_nested+0x18d/0x398 [ocfs2]
[13148.770968]  ocfs2_journal_init+0x91/0x340 [ocfs2]
[13148.773202]  ocfs2_check_volume+0x39/0x461 [ocfs2]
[13148.775401]  ? iput+0x69/0xba
[13148.777047]  ocfs2_mount_volume.isra.0.cold+0x40/0x1f5 [ocfs2]
[13148.779646]  ocfs2_fill_super+0x54b/0x853 [ocfs2]
[13148.781756]  mount_bdev+0x190/0x1b7
[13148.783443]  ? ocfs2_remount+0x440/0x440 [ocfs2]
[13148.785634]  legacy_get_tree+0x27/0x48
[13148.787466]  vfs_get_tree+0x25/0xd0
[13148.789270]  do_new_mount+0x18c/0x2d9
[13148.791046]  __x64_sys_mount+0x10e/0x142
[13148.792911]  do_syscall_64+0x3b/0x89
[13148.794667]  entry_SYSCALL_64_after_hwframe+0x170/0x0
[13148.797051] RIP: 0033:0x7f2309f6e26e
[13148.798784] RSP: 002b:00007ffdcee7d408 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[13148.801974] RAX: ffffffffffffffda RBX: 00007ffdcee7d4a0 RCX: 00007f2309f6e26e
[13148.804815] RDX: 0000559aa762a8ae RSI: 0000559aa939d340 RDI: 0000559aa93a22b0
[13148.807719] RBP: 00007ffdcee7d5b0 R08: 0000559aa93a2290 R09: 00007f230a0b4820
[13148.810659] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdcee7d420
[13148.813609] R13: 0000000000000000 R14: 0000559aa939f000 R15: 0000000000000000
[13148.816564]  </TASK>

To fix it, we can just fix __ocfs2_find_empty_slot. But original commit
introduced the feature to mount ocfs2 locally even it is cluster based,
that is a very dangerous, it can easily cause serious data corruption,
there is no way to stop other nodes mounting the fs and corrupting it.
Setup ha or other cluster-aware stack is just the cost that we have to
take for avoiding corruption, otherwise we have to do it in kernel.
-------------------------- snip  --------------------------

** analysis **

Under Junxiao's call trace, in __ocfs2_find_empty_slot(), the 'if'
accessment is wrong. sl_node_num could be 0 at o2cb env.

with current information, the trigger flow (may):
1>
node1 with 'node_num = 0' for mounting. it will succeed.
at this time, slotmap extent block will contains es_valid:1 &
es_node_num:0 for node1
then ocfs2_update_disk_slot() will write back slotmap info to disk.

2>
then, node2 with 'node_num = 1' for mounting

ocfs2_find_slot
 + ocfs2_update_slot_info //read slotmap info from disk
 |  + set si->si_slots[0].es_valid = 1 & si->si_slots[0].sl_node_num = 0
 |
 + __ocfs2_node_num_to_slot //will return -ENOENT.
    __ocfs2_find_empty_slot
     + search preferred (node_num:1) failed
     + 'si->si_slots[0].sl_node_num' is false. trigger 'break' condition.
     + return slot 0 will cause node2 grab node1 journal dlm lock, then trigger hung.

** how to fix **

For simplifing code logic design, We make a rule:
If last mount didn't do umount, (eg: crash happened), the next mount MUST
be same mount type.

All possible cases, when enter ocfs2_find_slot():

1. all slots are empty, [cluster|nocluster] mode mount will succeed.
   this is clean ocfs2 volume case.

2. for nocluster mount action
   - slot 0 is empty, but another slot is not empty:
     - mount failure. (there should be in clustered env, deny mixed mount case)
   - slot 0 is not empty, all other slots are empty:
     - slot 0 is nocluster type: mount success  (may crash last time)
     - slot 0 is cluster type: mount failure (deny mixed mount case)

3. for cluster mount action
   - slot 0 is empty, but another slot is not empty:
     - mount success
   - slot 0 is not empty, all other slots are empty:
     - slot 0 is nocluster type: mount failure (deny mixed mount case)
     - slot 0 is cluster type: mount success (may crash last time)

above with simplified form:
1.
clean parition => nocluster/cluster@any_node    - success

2.
cluster@any_node => nocluster@any_node          - failure
nocluster@node1 => crash => nocluster@node1     - success
nocluster@node2 => nocluster@node1              - success [*]
cluster@any_node => crash => nocluster@any_node - failure

3.
cluster@any_node => cluster@any_node            - success
cluster@any_node => crash => cluster@any_node   - success
nocluster@any_node => crash => cluster@any_node - failure

[*]: this is the only risk to corrupt data. we allow this case happen:
- node2 may crash or borken, and fails to bootup anymore.
- node2 fails to access ocfs2 volume, needs to manage from another node.
- mount.ocfs2 will give special warning for this case.

Fixes: 912f655d78c5("ocfs2: mount shared volume without ha stack")
Reported-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/dlmglue.c  |  3 ++
 fs/ocfs2/ocfs2_fs.h |  3 ++
 fs/ocfs2/slot_map.c | 70 ++++++++++++++++++++++++++++++++++++---------
 3 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 801e60bab955..6b017ae46145 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3403,6 +3403,9 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_nfs_sync_lockres);
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
+	if (ocfs2_mount_local(osb))
+		return;
+
 	ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 	osb->cconn = NULL;
 
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 638d875eccc7..4fe42e638309 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -534,6 +534,9 @@ struct ocfs2_slot_map {
  */
 };
 
+#define OCFS2_SLOTMAP_CLUSTER   1
+#define OCFS2_SLOTMAP_NOCLUSTER 2
+
 struct ocfs2_extended_slot {
 /*00*/	__u8	es_valid;
 	__u8	es_reserved1[3];
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index 0b0ae3ebb0cf..a5c06d3ecb27 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -26,7 +26,7 @@
 
 
 struct ocfs2_slot {
-	int sl_valid;
+	u8 sl_valid;
 	unsigned int sl_node_num;
 };
 
@@ -52,11 +52,11 @@ static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
 }
 
 static void ocfs2_set_slot(struct ocfs2_slot_info *si,
-			   int slot_num, unsigned int node_num)
+			   int slot_num, unsigned int node_num, u8 valid)
 {
 	BUG_ON((slot_num < 0) || (slot_num >= si->si_num_slots));
 
-	si->si_slots[slot_num].sl_valid = 1;
+	si->si_slots[slot_num].sl_valid = valid;
 	si->si_slots[slot_num].sl_node_num = node_num;
 }
 
@@ -75,7 +75,8 @@ static void ocfs2_update_slot_info_extended(struct ocfs2_slot_info *si)
 		     i++, slotno++) {
 			if (se->se_slots[i].es_valid)
 				ocfs2_set_slot(si, slotno,
-					       le32_to_cpu(se->se_slots[i].es_node_num));
+					       le32_to_cpu(se->se_slots[i].es_node_num),
+						   le32_to_cpu(se->se_slots[i].es_valid));
 			else
 				ocfs2_invalidate_slot(si, slotno);
 		}
@@ -97,7 +98,7 @@ static void ocfs2_update_slot_info_old(struct ocfs2_slot_info *si)
 		if (le16_to_cpu(sm->sm_slots[i]) == (u16)OCFS2_INVALID_SLOT)
 			ocfs2_invalidate_slot(si, i);
 		else
-			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]));
+			ocfs2_set_slot(si, i, le16_to_cpu(sm->sm_slots[i]), OCFS2_SLOTMAP_CLUSTER);
 	}
 }
 
@@ -252,16 +253,14 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
 	int i, ret = -ENOSPC;
 
 	if ((preferred >= 0) && (preferred < si->si_num_slots)) {
-		if (!si->si_slots[preferred].sl_valid ||
-		    !si->si_slots[preferred].sl_node_num) {
+		if (!si->si_slots[preferred].sl_valid) {
 			ret = preferred;
 			goto out;
 		}
 	}
 
 	for(i = 0; i < si->si_num_slots; i++) {
-		if (!si->si_slots[i].sl_valid ||
-		    !si->si_slots[i].sl_node_num) {
+		if (!si->si_slots[i].sl_valid) {
 			ret = i;
 			break;
 		}
@@ -270,6 +269,20 @@ static int __ocfs2_find_empty_slot(struct ocfs2_slot_info *si,
 	return ret;
 }
 
+static int __ocfs2_find_used_slot(struct ocfs2_slot_info *si)
+{
+	int i, ret = -ENOENT;
+
+	for (i = 0; i < si->si_num_slots; i++) {
+		if (si->si_slots[i].sl_valid) {
+			ret = i;
+			break;
+		}
+	}
+
+	return ret;
+}
+
 int ocfs2_node_num_to_slot(struct ocfs2_super *osb, unsigned int node_num)
 {
 	int slot;
@@ -449,17 +462,45 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 {
 	int status;
 	int slot;
+	int nocluster_mnt = 0;
 	struct ocfs2_slot_info *si;
 
 	si = osb->slot_info;
 
 	spin_lock(&osb->osb_lock);
 	ocfs2_update_slot_info(si);
+	slot = __ocfs2_find_used_slot(si);
+	if (slot == 0 && (si->si_slots[0].sl_valid == OCFS2_SLOTMAP_NOCLUSTER))
+		nocluster_mnt = 1;
 
-	if (ocfs2_mount_local(osb))
-		/* use slot 0 directly in local mode */
-		slot = 0;
-	else {
+	/*
+	 * We set a rule:
+	 * if last mount didn't do unmount, (eg: crash happened), the next mount
+	 * MUST be same mount type.
+	 */
+	if (ocfs2_mount_local(osb)) {
+		/* empty slotmap, or partition didn't unmount last time */
+		if ((slot == -ENOENT) || nocluster_mnt) {
+			/* use slot 0 directly in local mode */
+			slot = 0;
+			nocluster_mnt = 1;
+		} else {
+			spin_unlock(&osb->osb_lock);
+			mlog(ML_ERROR, "found clustered mount slot in noclustered env!\n");
+			mlog(ML_ERROR, "please clean slotmap info for mount.\n");
+			mlog(ML_ERROR, "eg. remount then unmount with clustered mode\n");
+			status = -EINVAL;
+			goto bail;
+		}
+	} else {
+		if (nocluster_mnt) {
+			spin_unlock(&osb->osb_lock);
+			mlog(ML_ERROR, "found noclustered mount slot in clustered env!\n");
+			mlog(ML_ERROR, "please clean slotmap info for mount.\n");
+			mlog(ML_ERROR, "eg. remount then unmount with noclustered mode\n");
+			status = -EINVAL;
+			goto bail;
+		}
 		/* search for ourselves first and take the slot if it already
 		 * exists. Perhaps we need to mark this in a variable for our
 		 * own journal recovery? Possibly not, though we certainly
@@ -481,7 +522,8 @@ int ocfs2_find_slot(struct ocfs2_super *osb)
 			       slot, osb->dev_str);
 	}
 
-	ocfs2_set_slot(si, slot, osb->node_num);
+	ocfs2_set_slot(si, slot, osb->node_num, nocluster_mnt ?
+					OCFS2_SLOTMAP_NOCLUSTER : OCFS2_SLOTMAP_CLUSTER);
 	osb->slot_num = slot;
 	spin_unlock(&osb->osb_lock);
 
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
