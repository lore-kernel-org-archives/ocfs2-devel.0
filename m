Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB632C433EF
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Jun 2022 17:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VibPLT1u/F59WYiFP4MiwwBpIkKnqFiS1inAjHi7D74=;
 b=GUnXFYzUX0/lzS9Z6Mu/giFtTCTlCbyCdq8X9TWkCd9kdGeozt9aJQucn2lTmFgOPcEVYMuL8DQM
   dn2Nc6lpQPApsVU2MBWeVzFbOq6d2PeH2AsuhoS2kwNBxW4SjrahJbm6+3UhJbT1/4Coqcv/c+vk
   Uv2bCgLtpgpQJqdl92OEOu59nb5KtIi/7F8xSdh3pTs0es3ehpr+y+9XAojn6MTtX6Z0QBemxUe0
   W0mAmZIrhOQq863mSJSyKtBPMNBI2/iRN7r5HfDAYelLXToemnm7KU/3m8hr7nh3KehBzNbzUJdU
   scH8IKoKZ41xnMVCelCkGWByYPNFL3WjHjAqFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=VibPLT1u/F59WYiFP4MiwwBpIkKnqFiS1inAjHi7D74=;
 b=druKIhjPnQnbDUtpcYQCvxhRNTPE+dkH5l37VBmraj4g4WHzRQpm3ppOJ4clQiRlnA4l2uLHO/+A
   weuvtKLgrNImBRsNJjsiV35tY+Im0vFJBXasktqcLjdg+/RFr3kCm92GYoMUUjU7jAJRfKELk2sk
   60skR9FxdUHUWbp2eVlUHohPbavqziaoaaE2z1LF5om+QCnDnciAfdw+mJaJVGLysHJs9uYyT9tL
   dqiNCOwXYk37eD5MhuNM5iTbvtV5YO3dOHBblsogZrihFVn2dEDvCHi2UZOcwPvQE25CPwtEF+0I
   svsxFZcJtBE+Uw76SH9LendKs8R0fUJTogU7OQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD400NDSAHKNR10@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Jun 2022 17:12:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : content-transfer-encoding : content-type
 : mime-version; s=corp-2021-07-09;
 bh=WXqUbSC/GO7ha3lAYWv4tIKf5ZhZ4KhfiJqUM5kav0U=;
 b=U5pMcI26DE051suLH43+x9rc8bO3NJ9GfV7pBJxmE2MYmtqF4t/ihzlOSNP7kCG52gpA
 Hl7xzBX6t3SVtIvFY9oa63ZQ33KzpI3ajZiP/kXOsUS5+ywdit/Lsy/FFgnjJ5gaFIBA
 +BZ/8uT48tkWpOC2DwO05ibz8Jjis9UsKRTaLwbtdNWprrq+nU+3hMbmn7r0fwe6ilEV
 rsHx1EFeKu11cmtsN2B47RD2CXIqc26KMXzjX7XJEyRM6A+ausqp+ZuBNw8iBHlEK2s9
 7YwiBqNQM2U1qXPp25tB+wFquWF3n3oDGh0PhkXiUW2ef3eEazcZBaJUntK+TQUzduYI bw==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxYUKQAYwXZ3SAH3cjYlqxGP7xBU/UqHP/Z6hZX/xMdxyvWYmIagTCWVyWoyIvL3ZUTfmsxotul2Bfw27FaXs0Fpd5mqMEddt7RGJr4BTXwHveBx8+YHVHSH0lPH78V/wUtsmcH//aBdlp4resxcncknV3Qhul5vIMrp2GDglS6eoAsXUTWTBdf2ySudx0qJaYXTZ++2GrCxDvcQADOdK3caIPvc/bpkZOB4iOPNOexp/fu8XL2LNWkXupDUN3di5Sfse9rYC6xgTMbRwjI756vSp/q7eopy/OlgZfMHQK605twXlkg34yBOHWkjTiX1BZj9/cLt4xL1x4LP1x52Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXqUbSC/GO7ha3lAYWv4tIKf5ZhZ4KhfiJqUM5kav0U=;
 b=JwjEurvINjAp7fACrB+IVYaVbmicPwykfr73dXGEmv0BXJ9eSyTWABwSdoNnp+6KD3AdP2mMBjsUHs1moOkjj58gIJtccZA32Y3qVFHK4Bxh2/QIMXl+0/+B03eJpfegflDASGJcZNeyot00BlgFXtsksKF8XD2gdvJD4aVRp4yXADrSIS0hOqr3mdt5WU0VIoel1rvxumVQCiftpiLwKdwwmdyDQ+SEfjNHI5/GvTs43GyED5LKxj/4WmKrJ5ODUQ3Q5hjkjJyVmuBH8BVAYHpzw3LQ8gH3zWtzDUl6HjGdZajktCtW2sBV+plhM/+TVS/4xbZcnrfKewILZbk5KA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXqUbSC/GO7ha3lAYWv4tIKf5ZhZ4KhfiJqUM5kav0U=;
 b=p28D7dPykqO0OFhH9We2RnN/aHQ6wpbz2VlJS4Y37M31Ugyx83YEJqx8LAcsje26mXVWEkBoenUfqA7rBYEIdWVgvUKIk0JeYTnY8ClNoCF5+e2LY/LONaukCrzONIN8T28HokfCYo5MzHbwbE9sIkjTvVmUqLL0nhJuo6qDsck=
To: ocfs2-devel@oss.oracle.com
Date: Tue,  7 Jun 2022 10:12:26 -0700
Message-id: <20220607171226.86672-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 17:12:40.5693 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,
 18.0.874 definitions=2022-06-07_07:2022-06-07, 2022-06-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070071
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: kill EBUSY from dlmfs_evict_inode
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
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SJ0PR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:334::18) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f64e0583-32e7-4a84-f8d5-08da48a8ed91
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 HYC9lowztlW1NLCPMm4h/YkGkl6yD6BcwWXWKZe3S4pGTjr4uYYMHWB7yrUEt3Dk7sUf626+DGCConSPcoxL/MFfH7B4yMRLJsv6aoqmHsx9tgRJoJXl+owYq0jxtCM9EVgna6hz6XK3EJsJEVmIZpg0MQX8z2fGEqqh/FiZ8+1toLmBPjapP14VsDkBEeG3STFF/UIxp6S0MMHe2sITKuZHo5qIRlkTzrqI0gZzFk18haFafqW/dZITfbC8zAsRj9DCEKOoTXRYzlerZmzdX38EEDrzUFmZ90IcfTbvqWOE+Rzqj2TJzVmn/kA/PqjS1+X5sG08Wpp8I73tAUVJPEjfJJc22jFQxig17mn8fAdhYPzZp4UtACKrkiSR7SKGUQHsfdBz/fDlnnMTLdDOBWAKel/dbZqA3T0JZaN8agXSrqueRP+uOoXZaHuZlmuzOPfFTGPAx0cJbvP13ZTru19T7NwTjGYYOgXIrTkcjp+IH0oDC6ko4qqVHb9R3a3tCeR+OkY1Q2pRVAaUpycHCW7HYk1Y+clze9vE82oiIH0TWTKrPD1nCgbAPC4+mW/MRZ66a36TrMIUowqD8XKUh9UxGYtNOksCSs4IE1Nss40=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 f64e0583-32e7-4a84-f8d5-08da48a8ed91
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 KWJ75lX63eIrVxU2oqMcO8uFlF4n1VPHpAKkNGMu1t+xvQLPdV9enXX2pipBY/UWV5SieOOOnmJ3cnjRp27KtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-ORIG-GUID: 9vCtisKY7yZuNbHk0THInwvq8GCDfpWZ
X-Proofpoint-GUID: 9vCtisKY7yZuNbHk0THInwvq8GCDfpWZ
Reporting-Meta:
 AAEMhLD67BtTO+glGKgm+OiJZS0FvqAD2BtMfc0UPpYuLU2q4y/bCyqAw8idOxzK
 U26xVa1H9yjOtmDEfmb043Nqq492vHe0099KnznQDqpmvmgDhRwQLjaiyCZcpmK4
 xjoqO+cr2d8k9M4AIzzfgV13f8qqUTyI7mZdm//ktlOh3LBxlgfalvdYdjCofKy6
 mnTmA2yQSnv/dbhHUsgYDQ55xM6WQ3YkI4G2BzS7TEFiCcb0x3n+zoUGYbhWuiJO
 BI0NP/jA4flnduzxHNHAky5zul45+SxTzVGYxlFh3GU2zdgVgBBKDXC4GXTWFeJj
 8KARtaLIs8GqVFJyd1X48Y4vfkrEYi+jNX6KgI5HOWgaufvWJL8KuCQ4uF7R9qQN
 oyb2H4dnHApqFPg+dYQXG+CHoRgBSH78mmAtHBVjluHtogJ3LZ1tRQNBtT0a1dKa
 xrW15fl1bL9orscqgfxtAzNJJX4bjryGpLAlTCc6N7nkm+viOXuHI2H7UNFqmNoZ
 VUMhWqGB7P/DEDSgtqrAbC1nEon8rKL0PzpT9g34BAI=

When unlink a dlmfs, first it will invoke dlmfs_unlink(), and then invoke
dlmfs_evict_inode(), user_dlm_destroy_lock() is invoked in both places,
the second one from dlmfs_evict_inode() will get EBUSY error because
USER_LOCK_IN_TEARDOWN is already set in lockres. This doesn't affect
any function, just the error log is annoying.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
V2 <- V1:
 - s/anonying/annoying in patch log.
 - s/destroyed/teardown in dlmfs_evict_inode()

 fs/ocfs2/dlmfs/dlmfs.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index e360543ad7e7..8b2020f92b5f 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -296,17 +296,25 @@ static void dlmfs_evict_inode(struct inode *inode)
 {
 	int status;
 	struct dlmfs_inode_private *ip;
+	struct user_lock_res *lockres;
+	int teardown;
 
 	clear_inode(inode);
 
 	mlog(0, "inode %lu\n", inode->i_ino);
 
 	ip = DLMFS_I(inode);
+	lockres = &ip->ip_lockres;
 
 	if (S_ISREG(inode->i_mode)) {
-		status = user_dlm_destroy_lock(&ip->ip_lockres);
-		if (status < 0)
-			mlog_errno(status);
+		spin_lock(&lockres->l_lock);
+		teardown = !!(lockres->l_flags & USER_LOCK_IN_TEARDOWN);
+		spin_unlock(&lockres->l_lock);
+		if (!teardown) {
+			status = user_dlm_destroy_lock(lockres);
+			if (status < 0)
+				mlog_errno(status);
+		}
 		iput(ip->ip_parent);
 		goto clear_fields;
 	}
-- 
2.24.3 (Apple Git-128)


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
