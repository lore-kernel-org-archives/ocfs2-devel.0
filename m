Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 208D5C433EF
	for <ocfs2-devel@archiver.kernel.org>; Sat, 19 Mar 2022 06:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/a1ya74IWvQ2MSLvS6NpBA3wv4nyB2DZz77YVjEcECo=;
 b=snbCJWeStg1EsCbo/1GTUpBXiXizytZuajFT0emlFNdTXhriJMQrk6+r8N/kNHe0JAyV90IUcKLE
   uOdjjuwWSBR/BHNX8wp32iiYdNOiNCBGHm71OsHza+NyiAgfjY+XeqiMU8HgOmTQQdVMwPhHaSbB
   GkZtli4dW7KS92MB/s1aKr81IcQ3N8vDw94PSE3eVPE0U9PgSollmv6yjRxkcdIt99ff7Ce8WuT3
   9S9GjyrmtOosDpJvpNd4WWqot9wI0ORJ3HUFNIJvM0Gs+0czSm7+zqhfPEGD/DjTwRfsLwvsQ9X4
   +B6uEBXG252frqjIOJNukk22xwRWJfWsNh6xwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=/a1ya74IWvQ2MSLvS6NpBA3wv4nyB2DZz77YVjEcECo=;
 b=RoHvalPWUB6ogvbstTCKwj5kRUmNqE8y+t9gRGwjbifEpMYbahpf3g86v0y87NvElaWrynJ/XbG3
   WVl0Sp/o5tMGs8kUFYQjoPl0Tn1RiTgp4yGZxufASEUYXCa5dXlCE7Av8UPSG8Vx61iP2m6Y14ob
   6QwKaNVRcIgzZY7dWV7N0cV5bc5Y7a5hgWquLyt0jQBCZt5WNtYkfkWuU0aECJn0VNdbZnnG4JH3
   9QWqXJE5WdXXtWbp3azeNWfFE4uxAHtiEVgl3jZ1WoAUouYEh4WdY4GPDkEOfQ/4agZFioKhyDOV
   gLYoe65H7TbewIdxhAxLD+4DxQTuCfTzS/TI2g==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R8Z00JOYAIITA30@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 19 Mar 2022 06:11:06 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=permerror
 smtp.mailfrom=yili@winhong.com; dmarc=none
To: linux-kernel@vger.kernel.org
Date: Sat, 19 Mar 2022 14:10:28 +0800
Message-id: <20220319061028.3152-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
MIME-version: 1.0
X-Source-IP: 59.111.176.71
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10290
 signatures=694221
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 clxscore=213 priorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=586 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203190037
Cc: yilikernel@gmail.com, ocfs2-devel@oss.oracle.com, Yi Li <yili@winhong.com>
Subject: [Ocfs2-devel] [PATCH] ocfs2: refactor the noqueue_attempted
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
From: Yi Li via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yi Li <yili@winhong.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
 kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWUMYGRhWH05IGhofQkpDTE
 NLVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PDo6Iio5Fj4CDRoKTyo2FRcI
 NxwaCUNVSlVKTU9MTUxLSU9KTUNDVTMWGhIXVQISFxI7DBIVExQVHFUYFBZFWVdZEgtZQVlKQ0hV
 TVVKSk1VTUtZV1kIAVlBSk1CTzcG
X-HM-Tid: 0a7fa0cca8aeda56kuws42c0f2e0023
X-ServerName: mail-m17671.qiye.163.com
X-Proofpoint-SPF-Result: permerror
X-Proofpoint-SPF-Record: N/A
X-Spam: Clean
X-Proofpoint-GUID: jKcemvw-IFpXztYq8FS8c75s-5wMPCHp
X-Proofpoint-ORIG-GUID: jKcemvw-IFpXztYq8FS8c75s-5wMPCHp
Reporting-Meta:
 AAFyrV8HM1xKzADgo4gCRNz/1UaVHECCe8tSiHOHYmj9i4010V+uAeoFj9GolO9c
 7KhT7VDmnm/BXXOYfNPnTiT1LVd96vF0HpW6aHAAKvE/UDOfdjaBxc5l1tOo815g
 05p2k3NJfi8wSBM97a1qeSDUTFpg+EoCpwFlpES5xV6Er+dwrYvrJClw/e6f0DzF
 fUjUkNF/JXJigo3mzBo6VKAgNvgB3W3+78LDAcDW6je25kGEm7gxsWv0yWsygG1a
 aJlCGJytk5fFQxfAPflerD58HEjgA8MduBbTOlMHBx8le60nnGejXZ5vI4f5a7lw
 urjqKcfE1wJS9Lkm9vzBjQQyJ+Wjw1gySjHvIDxlp+PBGtslQC679JHjC88suOHj
 66zVV5skpLJBSKGtJf7MkND5yDYHXoRueeG2p6jJCS2aK7q9MHRC1XIJMYBmxJJz
 msegofHOmvv3jdCYEkmIjUsX6O3LFHkwGBz9P4aj6e2czCn/cEza+FjEh/8MWMbm
 LLZwMybgXgT/Dx6WhH1Erv68DRIwx2FaTwAiQT40LrI=

The variable noqueue_attempted just set when DLM_LKF_NOQUEUE.
refactor the code.

Signed-off-by: Yi Li <yili@winhong.com>
---
 fs/ocfs2/dlmglue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 801e60bab955..6315757c164d 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1547,12 +1547,11 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 	}
 
 	if (level > lockres->l_level) {
-		if (noqueue_attempted > 0) {
+		if (noqueue_attempted) {
 			ret = -EAGAIN;
 			goto unlock;
 		}
-		if (lkm_flags & DLM_LKF_NOQUEUE)
-			noqueue_attempted = 1;
+		noqueue_attempted = lkm_flags & DLM_LKF_NOQUEUE;
 
 		if (lockres->l_action != OCFS2_AST_INVALID)
 			mlog(ML_ERROR, "lockres %s has action %u pending\n",
-- 
2.25.3


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
