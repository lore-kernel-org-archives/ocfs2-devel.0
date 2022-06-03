Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2069C43334
	for <ocfs2-devel@archiver.kernel.org>; Fri,  3 Jun 2022 22:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i5lyTm814sYRneIYICOvLiMjVPgxzE5WD78qgDn0Yro=;
 b=fh5u8iEh3UPxgMsUTn3eg9X/t5iuk8WaEOWQt/bMKwKqxNayZGKf2QDfFe+rd/Bfrdx9ZF0+0Xwc
   erL9C0k+QNvtN7N147Vf/O5qQCcm5/Px6TJLjQCKZvYFlQd6TgjSPanrSTdiVMSiU6Uh5+rcOIaw
   D054Z34PhOVSqxjkdkda/A5W/4jQQw0e2oyk9fjzPZCc5KjU3WqIDTljncHmj07xKo3OJhrd+XQz
   HHq5RczyHLV1nhrYHgIfDLClJy6t3UFgJshrppbD5ZTJ/0ZjLjSyWBoH3l8v1piOxvApwT6/a51Q
   v5B/7edrEADB4DWY1Jx9K29FcIXBKc+uokPuMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=i5lyTm814sYRneIYICOvLiMjVPgxzE5WD78qgDn0Yro=;
 b=fD7ktSPivgk8kcp68eIYqfZHaPX6r+R0RbwxMDnOuivXly1WwP+3t4UilFxE4DqSVl0PSlJu5p5G
   uhRGjiUHOxQvwKXJxmm72w3fDIVckEl1U0JBdf5M6lc1qazfh2IkSKjMjrbcz41OPK/29SrTY3F6
   OgTz+kvqSYxXY7THgIbQ8QaVVG3GhZnv6vUt/BheYg1jcj65AxbGdh9D16knGfdmHI8qejldU5Yh
   t+7kn3gaQZHWm08y2KDpVMlErKxgqZZhBx8hX3kiPga3DvJfZ6wdhjh0fUGbuFNZ4K7njFcjmH6h
   wr2rMa6W9HODc+fMLR+dAq9zDbvH6E3wFyNoqw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RCX0042LAKNNQ30@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 03 Jun 2022 22:31:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : content-transfer-encoding : content-type
 : mime-version; s=corp-2021-07-09;
 bh=nrfba8tBfJjz+i66hVa6nQI8jkdolBtgakY7+62RS8A=;
 b=Cg0SaqPc10nDz/K7e7ESzg9EwkyUL4mrMI5TyIQHOMA7yqvAOKj8WNcgjPVXzdo8KVzn
 O8hIgmcADUV0igO73B6khFRHCzGMjB/NI8GOucaO400XjCpSE8sn+rDnrixrTX9NabFx
 YLNQAMYUALdLEyEneAaxQzMwiNkR+DLbdAvnzYxVe+FdZm7q/qRUJsEL1curr2e1n5As
 cVSuiz297+ELRDVW7hz7M4sP/Q5pcVuU1znVj2sNHSOmvlUHj/yzPF3R7zCJnTkFINAX
 bvP5NNPctB+tWV2wD+sm+Ur58Ecq3IRBG1cdz2iWGSu36nxumGvVJP2Y0Mhq7aOKaFWj Zg==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATTGDYxF2ntQ5bY9Qko1YWYmdjQupTY/hX82k0KT7WWZ7L3VknizLcoq61nmMcNWejy4PUgDjtuJ/iGBz51io5qFfhz0hmYRGsxBnoLqM5Jyt9SSC2za6yJKR3aVMfyvhb/lEvqZXJYvqH3wOLmx0Bu4dl9Ng0RxuPppppJrrtsebDLgAePYzG/eQDnk2f1ffK4JimUk81ZLeDeKl612OsKbWcFoWyhCQcfGdiQaKSnmq+BcZIQHWMhGOhhtxVpeEg2mV3mWdpb5Ur73zeFftf2N0AcJbY84Hn2vOwGsp6BIU1RtHZaEK7d0j4fIIMltSxbjjpAq4GndRdUmo2HOug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nrfba8tBfJjz+i66hVa6nQI8jkdolBtgakY7+62RS8A=;
 b=oP34vgt64uuF4NlL+CYjwW1tG/YP/ikcKhtx5Yi9EnKD+6WMI9tVPFqOVWTXz+0uSekI6F7t/JPu0TUJI2StlYqKGuqUfnQELtxqAR6mYaG7qL0ACf43if2OEPuYvHp9ArnzM/fXty23dOgM9ff0wavN34R7bNZ4mnG9qsSTxM7PL1Cg3DoCKBpkZXUmxrhjWJEjErYkTv+CrWOXza9RLCyDqXuL82lo5cSD1mKvvScoTG4iWeIzAelg3PU5vtFA4YNidpYydbHsjFAoAnLsm84pxEbq7wlHzLL9qgHbkDOnisyl+VmHuuqPnnBdNgZdALEGUiR7PkBuD3ZYs+3AJw==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nrfba8tBfJjz+i66hVa6nQI8jkdolBtgakY7+62RS8A=;
 b=fNOY81n/epDuoivNzy8Gv0tpeaH+TO7ab1ihTR1ysNE6ETkiRwqA3xzYREGqldfJ+faQPOpThdM8V+hFQ65YJzJKFW3wl3VS2zYvz1773JhjmtMpeKc5dwMVTugFUpUrAnli3dvtRFv/tW2JCvIhherWjjljVPDXky1ARScK6jQ=
To: ocfs2-devel@oss.oracle.com
Date: Fri,  3 Jun 2022 15:31:22 -0700
Message-id: <20220603223122.43174-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 22:31:23.9057 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,
 18.0.874 definitions=2022-06-03_08:2022-06-02, 2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030088
Subject: [Ocfs2-devel] [PATCH] ocfs2: kill EBUSY from dlmfs_evict_inode
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
X-ClientProxiedBy: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57c32f15-98bd-43c2-277c-08da45b0ca4e
X-MS-TrafficTypeDiagnostic: MN2PR10MB4096:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 RcMjVtl8R/USkw8D0PBKIwFAwutaldh3DZhYVnmfZwxM+8Q2mHY8fVIkZBFA75Finth13GFWv7y/1cmml+ZhwFQt3nK8/BkC8JCBeBBk0cFZgbD3vc/AtJbp12D1D3CY4dIPidATIGMVg2AUhbjfbKqGt6Yz+wTbcxGQttaG+u0jubZJxlMjLFYC7FX+DnLx/Dkqpu0CKGTKROBYDdzFgsx+Nr9BtvSGvmK6TJyS64Pgo/Wt1OizzvUdK/ChaHzlrygc1NZEVxSZYY4JuNuIuruRF57WU1zUkM1EFIZoEPI9aL3PFSg002i9W5QbLW0Dn4K9R7mILQc4oavqlzXISoNehb3GEH+kpUqBN/TxorfP9w7xkLbn6ibQECtrWNUJ40euhjkQnzMPC0d7wWo0vI+Nw0NCoQ+CHJFai0f6NyFmjjA/tn5tYV8rdjruUrY23HyH+xbJDmhZYRuJRYNOZ555Ia0v84OOOmdk/q/6dRc4LWHNCFgTYqvZhFBLy3IXrEulEFGqGTpX7fnOMXYs/Js+hJwoV1PS8fHqDF3EolN1wwXbZAjsSa+JIn7eKFvQlFFOaKYvdwUj8q6OkEKX4R2B9HlKqyJSMhD6X/VMRzE=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 57c32f15-98bd-43c2-277c-08da45b0ca4e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 Kj3bpAGlo2XeKwtyCY8RiOE4svVJz7kY5QKk53w8Uj2EvUqeucO014fmNaHuoJXajqJTzA+Fq6fSNN8TSQNg1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4096
X-Proofpoint-GUID: IzxOZI57baAayX9udUW-hWvzpW-gt5o8
X-Proofpoint-ORIG-GUID: IzxOZI57baAayX9udUW-hWvzpW-gt5o8
Reporting-Meta:
 AAHrkgEFjqG7y41irysviWwPR2WpU9TIo0p8N0m10YFJJeSiI1s+dwo22ByiM6K7
 Qd8IgFHrNfSswdEZ1RKG/5wEukgyMxXBg7YwNL38I4tRWsQPNKE2tkYH/0B3oBRX
 EqR7SMnWkrMUZ03f45ynoCJSMIg3WHlCPDjUAjeLeBWbWifUDhHp6Y1Lfn9hNEEa
 b4eNZ38o0A9dvfArMO39mhJBv/ZOu6H39mJp+gY5QOVvXNx5aYJY5hs1b+XQgib4
 VI8g8bpOdQj+fdugUQVvUnAlhfld0Y6ui5vro0mG8718Xiv5gLfHV3X4LZ4rVud3
 xqwNMbmAkEtc3rJIW39UIWVeD76+VYeC0tAxHOR7sPYrSGZzYRWLHVxEepb+W9/q
 LKd+um0ViKZlkNNyK/6ut/3VCKVi07VsxlHQHxCs79s6Z28mUMb8AhlVk2SJ1dE8
 VUILy2tIySECMKNnUjumzL/FCBR6WNEqipd5gsN8PfHet74IuEhN2l0WxojU8UQ/
 rCGP68ZovruiJvV9yoqY7RMxg0x3BXSYLP4H89OIepD/

When unlink a dlmfs, first it will invoke dlmfs_unlink(), and then invoke
dlmfs_evict_inode(), user_dlm_destroy_lock() is invoked in both places,
the second one from dlmfs_evict_inode() will get EBUSY error because
USER_LOCK_IN_TEARDOWN is already set in lockres. This doesn't affect
any function, just the error log is anonying.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/dlmfs/dlmfs.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index e360543ad7e7..a120610dff7e 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -296,17 +296,25 @@ static void dlmfs_evict_inode(struct inode *inode)
 {
 	int status;
 	struct dlmfs_inode_private *ip;
+	struct user_lock_res *lockres;
+	int destroyed;
 
 	clear_inode(inode);
 
 	mlog(0, "inode %lu\n", inode->i_ino);
 
 	ip = DLMFS_I(inode);
+	lockres = &ip->ip_lockres;
 
 	if (S_ISREG(inode->i_mode)) {
-		status = user_dlm_destroy_lock(&ip->ip_lockres);
-		if (status < 0)
-			mlog_errno(status);
+		spin_lock(&lockres->l_lock);
+		destroyed = !!(lockres->l_flags & USER_LOCK_IN_TEARDOWN);
+		spin_unlock(&lockres->l_lock);
+		if (!destroyed) {
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
