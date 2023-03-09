Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B76BC77B60
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KPcHncH/Wb1Ubb2OKvPk7W5wcLaaGkPm0v9iE+OV9Wk=;
 b=THBFqi+5dPKM9VUFnw950hb9pTzsjuf9uB5woLTMJYdGRY9AE8niQxqpyl78hcFdyafDx6AAcKkE
   SyN+bgS6dIJhWQW0OWLhtR3FGov4qU0bzzHEC6kip8nCe3P4F+9YBEDtZBJISgoCRqBZPFfki798
   hD+J1E+L1RskkI6tqqaI8CVuxOUgrKzE94g+qqJJqRDWFmyWLvdw3RB0LqpGC3vKFMPN6hFqJML5
   PS+ARE6hvqSLd9evEBimFzdfW1bCz8xhAjoj0FJ5rp4gxFZcoov0mCHZkcDRn1NyeIGIHTgmfORA
   jiMhu/IokSc5nuJBYwZ+OQ4JCcDp6qIWXDG1qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=KPcHncH/Wb1Ubb2OKvPk7W5wcLaaGkPm0v9iE+OV9Wk=;
 b=iPDi7kB+llLoVukxfWBr//9/igHO9Kf9gN7dPDKKFVMJvMEgLabWcm+kp5S8vNiTGhglZLUubvSR
   a5Y5vTcgUKVHUTj29L7yk892rrJYS27wiaeOc9mOWhVPCGnAIYe8wSuWecbRG8sZv1441n5R91qz
   kuUJYdpdo0GHd8IrkV0TiZKUp2BIULBOtG5+5YFcY4B17sxNabzrTEVqBmHG1Qiy8TOURnIL5t9D
   O08U0nV8BmkKOidj6DuBda4XjE5fH8plcyEUjnSPvC/ld1V/vRiegDpAhDMlgfRhjjOq40d6FgPx
   vm5eK6ug5C5yH3IDG27ypb/e5D5f3eRAQUHYVA==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00CZ6M16MR10@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:06 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odETv7lDPYNueYF0EnAKbcfUQzcYdBA+BccCukEvJ0kBpHOM+d0+t95BMpeee4ssKLNltnTqgRVBVKjghC1/euOrVLTZAsl8Ig38poUh7I5IDKIDtLyisT66wbGUuEZ/v+rHvqzWj6gfq2FfKHlLjhOZxObHqEGuGACs/Luh8XMi+ce4qSp3gmRGgVNUcbcC7xJ1Q8T3ZlHn4HdVdfGcAmjiZQ8Y0UWhO4e9k74KHT+plen4VMi84Go1Jd699AMgtLf7TgjIE7hyDrxCLZWje9/9MM6eZShtwpImu8I/mC/dnWvIpjzUh71tZZzXEN9Ho5glYp8npU4qsLe6OtWxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xyp6khKdIkhA5xSLGNeZkhNG4sPGA+gYtVZl2iVCnv8=;
 b=YSqf2sWkvyZFXstIPrZ7IQ35FDo0ZzXBbYbnFbiviS4Lm4krbWsyIM5doOaggz1l3vTkrftYHBrUlNmL/NvPIxNtiS1z3vMAJQBX7jp9jIqHVygvh7OYeSD3Drs/rbCxFidUaiRjcXsmWxunal30cLmO3rU6EOHC5MANxnl52dSfo4osy4THBUXjV3qDQmrsDuJZt6urdxruCimtvGDpjXcpXkbVGLlVFRq4WgBwELkHIu7Ic6wTiq4qnBuCPxsgBlscil0hGoixJtrXUA2U99INjEa1jkDRi5VOS6fMqa7ovatA+9r3WVHqm6u52sSguoCK9nFaS+/X8juTZ/YVRg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com; dkim=pass
 header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyp6khKdIkhA5xSLGNeZkhNG4sPGA+gYtVZl2iVCnv8=;
 b=TX5bYM/ZQEqj6ynWAyqFFJLtnxP3cYWT+bvBmtHfmXB/Sa7xlbC0MuCu91miXQfw6o4qoBP7p6owdJSQ84PGuvQMOaa/nMr8891DsEN+ljgGTuFXFPNkuCG8BBdp+xwNYo/lMxEdBgYj1Z2npcv9W7iBeFFArRXh3VIJOJoFa6F3Ddn/DAHLBDAVQtjW0fS/q5QAzGRqs01sEuX/VYy1d485P1CF679jNnMAlbP80ia8DqMfVDP/3si7qLBwEJS1aNrsdeviYA9RR4CrZqe2YBacN5LsnlTae4+qMk1shKUGVkfJfGjfz1V99XM33JuwnGATWqU2Hscx+16hKQyFSA==
To: xiang@kernel.org, chao@kernel.org, huyue2@coolpad.com,
 jefflexu@linux.alibaba.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 rpeterso@redhat.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, viro@zeniv.linux.org.uk, brauner@kernel.org
Date: Thu,  9 Mar 2023 20:40:31 +0800
Message-id: <20230309124035.15820-1-frank.li@vivo.com>
X-Mailer: git-send-email 2.35.1
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SEZPR06MB5269.apcprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199018)(4744005)(36756003)(5660300002)(7416002)(83380400001)(107886003)(6666004)(26005)(1076003)(6486002)(2616005)(52116002)(6506007)(6512007)(186003)(66476007)(478600001)(921005)(4326008)(8676002)(66946007)(66556008)(8936002)(41300700001)(86362001)(316002)(38350700002)(38100700002)(2906002);
 DIR:OUT; SFP:1102;
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 12:41:09.4338 (UTC)
X-Source-IP: 40.107.117.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10631
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=104 suspectscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=758 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 clxscore=340 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090101 domainage_hfrom=9102
Cc: Yangtao Li <frank.li@vivo.com>, linux-kernel@vger.kernel.org,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2 1/5] fs: add i_blockmask()
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
From: Yangtao Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yangtao Li <frank.li@vivo.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SI2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::14) To SEZPR06MB5269.apcprd06.prod.outlook.com
 (2603:1096:101:78::6)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5269:EE_|PUZPR06MB6054:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eae045a-6ba2-4a96-7172-08db209b8ee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 6P7++5T/2tqGKxda9iuUKw8ulfTUUCg6+UoNEWVIwNSjwA0epc3XEC1YFz9RLh4sSlWci34CCE1ylqMfd5Wv8cewLK3O8QKpg3kW5xKUQXMIPokQVHmwhHNHSr2FTd8oJZlTHA4M83vAhzNQqPgoaWGvOsTblnNSpDrINP/sRffSMe4YIRvKwJvmq4QA7Ojsd18NLMKh0EoyHenKEVZO7+fY9M+3dMA8N/eH5SJ6ez4opLM+wEHZ3HiJ8YrW5tu+l9THAo95XU6iaof+xB+iYasxA2WAlHAqLdZv/oIP0F2MnpbOg3b4WEwLrE7MzB+t1AaPZUlnSz4Ff0QoKY4UVKKwNfbsAOC0XGEslYUmVWbbbGG0rIY+J7VJszha1uEjcW46BB9B3vLAUYYjDm0KTMXKUkBMkI6X+hNQ+tZpkAU3cJgDuEySrz7tVxJL3ADuNfKSgEjb4vITTzsSsJsZua/RfI4MOTeJxFlLvwU74kkH+D0U6oy8H62p/hMjnpspfGvmZ7H/jRRbAMvNzimghS/GxaI6LqX1l07wsSL98kWSDjbzSXCzxmPP/j6C4XMOooyqar24Ao1WvVzYTd2rAOPn+M4aO0XJQCflH0S/uHl/ZurWDrsZ3s8TKSpWHebHiTFJXLMMBe8hlXl5wGiHn72OEhdia6zM8/l1KBq+YFHUz3oTTlvmYmqVXTfWwnHU0l43U5xYaVO6dbOuoFU1v4WxkthZkhKnfb1cpEo7hbI=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?qwUd1U9/ddEhpB5ym1KhX/c+Jrt5cpwDYPe76437Qh0GFP1W3XGo9N7Jp+7J?=
 =?us-ascii?Q?z8XOi2+403LUHNwtqmHA5tUEmsJUwMX8yjLSfNGiZ9ao6gbpUf9DUDuO/Sak?=
 =?us-ascii?Q?/AbFXwwhUOhsDO8I4jqj1fCZP1DqR3wtDu9UpNR5G1s31KyhrMIPwW29nXmK?=
 =?us-ascii?Q?CAH5nKSM6ghRhTVuVQ7yjxBN9cApwhcORjiYyPf4A6Wpo09xhSh/+XplQDaX?=
 =?us-ascii?Q?/7lkW5yHD8hxhkSOmwF5z7yJ1ezQ1qpBBuc0vzQkXPDKTdR5RVRuDNnMNSYW?=
 =?us-ascii?Q?e5fMSTXoL2dLZntSxXFVEqsLq6QouBPfO5aVmGf5q04fR6NAoFQbw22WAQuS?=
 =?us-ascii?Q?dPrJep0pLV4TlqV3APbH9MDaAqJmfAfjcIeUF0AKGx5MYUOc94knFjcTbLrR?=
 =?us-ascii?Q?BpY9m6dd33yBblVODvBiCbBGAX2eR1XHVk9pbjtpN/gjulLc8pcaTkt1wmE/?=
 =?us-ascii?Q?IpZ+2lFrR3p7IDLvsfunxeBN/vK5WO3S3NyqaTCKzARPIJ0jMoBQR7dW4Bvs?=
 =?us-ascii?Q?XfC6HOtiFthuKBV8dz4tOEOkSH77AnrsXXJxRyyMg4ONhI77vrzbTWGvNni6?=
 =?us-ascii?Q?5JYKauIwacNdaMTbNqRb6WX5FLyOfGPBL3zpGny4TffQafW7Xe57vbrRpb7i?=
 =?us-ascii?Q?1egJQBp1cTW286wP92BSDSSES0wBxVK68iQh+TYH2ifhK/jit8D7g3yS+66l?=
 =?us-ascii?Q?qUHPkbtPDE1fTgCrrMqM+baMTeVxmYMFGQE11UU6scs3NiSah49r951GpYqN?=
 =?us-ascii?Q?mNc0dyfQA2gfE/vJFIQOjFuwTm39Ncbtt6GERbDPdlqgrQGk0+eHEiTyGtmi?=
 =?us-ascii?Q?QTXsbVJ0yVU14o/Hlien5AjdK8z/CwsVCyQZ6xWopCfdV9RE1+hYmjCOivcP?=
 =?us-ascii?Q?yZAFmyKj/4KHUJjB74hK2IUKGPIGOYrmdFDLGlb5yaJuC11GwLX0jk6F3YKY?=
 =?us-ascii?Q?O7zxkv3+dyCyvlXg+5y/agU51wKtlGXRmynLz4K9kSxHY/wMhWDS3cn6TkxH?=
 =?us-ascii?Q?oM+D+nwbPwO0YxGSd/9K/WCzeyXoydYcl4zgng8A3VzXpHc6p2Gibw2ZCcvv?=
 =?us-ascii?Q?Igt/EKLXgs08FBrPoKHJ19D4hlk1xe3m6OyvX+A2v4syhmA/MtX3huAZFDlu?=
 =?us-ascii?Q?NDEaeJxkaIHS2U0P+1ugrx4EgT9zT38+Dzra5TmMYUEdf26LhM0JqBXABp2j?=
 =?us-ascii?Q?01d8ZWJHUGo2PCqBKt8K5gGVKtOMwF/zgEIKVtzX21w9OLu8Stj1zmUXvWbs?=
 =?us-ascii?Q?IC3N0LyUuInxob1V9ABPenQt7HuKzMUK1Uf6/+mbiFJsF7HzxJcfeV43N+6G?=
 =?us-ascii?Q?3LmwYSZwG+V9X6DAGPYfxWhdfdAHutIeh1ioookV/ax2ITMrUuLlqIQKjIGj?=
 =?us-ascii?Q?4g0g8UePAGa4otn58WXE6XM4uR1A2nbKIpXbWjKbBCr0DT/gSDr5c9NtfvVR?=
 =?us-ascii?Q?F0KJHc5jIQXmpgX0C5pA8dDRQSR5fpolU1uBFKDifIkBuQEtHKG72XbpZD+h?=
 =?us-ascii?Q?GXzIiLhhf85vKsFwgjGDDVObDqYOL1ZFIF6WdnRHzhhWNhmlrm/qkL9t61Ui?=
 =?us-ascii?Q?CbrNvqJJgvSEJA+OBOquxBi3z/oSpzkbPsA+rXax?=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 6eae045a-6ba2-4a96-7172-08db209b8ee0
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5269.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 hIwsa5dMsMOPNVWk3UVyOvQAp9MVjcVoSIKUNaLd8ql1Zznrw5khsn1CPeaHJtkuSbq3UFTLetoWINaXLzFwnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6054
X-ServerName: mail-tyzapc01on2124.outbound.protection.outlook.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.protection.outlook.com -all
X-Spam: Clean
X-Proofpoint-GUID: E5PZHtup5iFjP0Kc9_FKxJaaJdylCJNf
X-Proofpoint-ORIG-GUID: E5PZHtup5iFjP0Kc9_FKxJaaJdylCJNf
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAF2ZR2AfcWj9C6hRzKffIFez1A4y/BOnktonO7NLGDJcKz+ILtJptIP0diSvwpV
 0hZMpCogTOpWjtLGGhZ+3ths9YiwQElOkbqWfrQPMa29gTqmRL7CQx/TcRyzkFMH
 bksv8BNI/3Sa9QDgP6XcAM9CNmYl2/r3BN2CAdPneRheryVk5q02tpJeoHNjq+tQ
 yl5FfyfRzW6wY9PiKgxowRijEuzFg2ZtOaVno477vkWZVEnQ33sBbGhRKR/ODA13
 XQetHTDWRZukDs6TX3VNrbsvXtqxWlJDlFsnd6PMAtNYt75SuGApaTbKqd8IwNWW
 yi4X00OLg+WgDWO27f6J2F4bUjUESTGlilpe7/GAL4jcd7mD5pCDcL0gGuKXnxoZ
 dnw3cGF81bcQJ6kPE3xGstrGthiaSWiOlE92Pw5Z50DpH2KTCxO1lsqT+IIxjaXS
 H7u6aU+68Hz6OStaGjy3qcNIJQqqip0pt0GHJH5JXRKwHnh9rWEMcgnKNBezw+NY
 obj8hH6CcIwjJHarrJthAWKWYF9ZbJc2bfu3Fkjq1Egl

The message from this sender included one or more files
which could not be scanned for virus detection; do not
open these files unless you are certain of the sender's intent.

----------------------------------------------------------------------
Introduce i_blockmask() to simplify code, which replace
(i_blocksize(node) - 1). Like done in commit
93407472a21b("fs: add i_blocksize()").

Signed-off-by: Yangtao Li <frank.li@vivo.com>
---
v2:
-convert to i_blockmask()
 include/linux/fs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c85916e9f7db..17387d465b8b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -711,6 +711,11 @@ static inline unsigned int i_blocksize(const struct inode *node)
 	return (1 << node->i_blkbits);
 }
 
+static inline unsigned int i_blockmask(const struct inode *node)
+{
+	return i_blocksize(node) - 1;
+}
+
 static inline int inode_unhashed(struct inode *inode)
 {
 	return hlist_unhashed(&inode->i_hash);
-- 
2.25.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
