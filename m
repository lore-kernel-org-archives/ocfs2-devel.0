Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78A06EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0Ghc13FFFWoUQ5xC1dLshFpIuYwW0ZF410jTpzVIX88=;
 b=yfvuItRNK743caJroVQQGrrNMN6HVX1IObbNqQuwnnTCxHIU8d3KrV3e6Pn0FiOCSQGOxoCXJ3ZI
   oFPWCMi0G/3JkXEutthADzlPz6qZ2iMxa23OxR7IL2lXJndN6ajVHmsCeWRyTlFKeZQL+sCxyBce
   ia4LU1mrGJuEAviHzoMHvNKTXNWaudt+NILEjw35YecOHmYuYlLHlJdNT5E8j/u/TKEpSCq7cUfD
   Dk3bh/PysjmUHRdRoiIe9s9jfYlWxW+DGd2Xm07mZ/rSgu6yBHLNMoO1D2n90zfSkOG4hhwZKXab
   MXloivAC//YB7siE1arVsID6dEKprk7MIvIYJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0Ghc13FFFWoUQ5xC1dLshFpIuYwW0ZF410jTpzVIX88=;
 b=sFVtd7OXyfIXaFQnwhBo+YKfICvvP9veIS2Z8x10AsYxeUkpo6cKPekMBC7WXdr0B7atrz3Wq1Rm
   h2qJKmZX1XDc7lS6f4R9IqExxh/7vgpf1Yguy8PDqydHTuoNgKN14cNyo8iF6238TD6ELJfcqcXN
   dIQTcxq3J1mdhyUsFJZFExdp/aiHoPYT8kElSF9WTdoa+Ax6r1k+gxhqySDjzv4umHRfeRXf3OB/
   HAxpW6KrFmPJlMuYY6rsqzjkALc21GQPmeTovgKNmUnnA2qMBvpAIhddkIpYfAGlUT+2FRiNe69t
   n/dSN6caIHn4r9emfl9A8v0zYOw77q/mCFsbMg==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWK000C545YR2C0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 14:56:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687209524; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=AaIvbocbXnLddTJMfkpJqlY+SicR25hAKIFhPjOIulppVG/MQ7mBiD+X9ZfeDzCT6G
 ZhmNMLMT9qWk5HQYS/tbm2VJnWArlDt5rybEIuiyaOV8QcSI3IS0yaY7gXmoj8TowWmm
 zoHLeIIr4JKp/O2mZILLcTlo4XBCvTt7tHIlX2k6Ygqm1xmoFV9tHoak5A6i1sdAkNYg
 emjOLMYe6V3cl15uLorq3YPtvqUUEWhR0AGo6cAZ2rsufFfqdLlBH4L2cPwfpXDKRSDy
 SGPqyqHI58TfX/YdfLaY/Ikv76gRJfujCD8UzuJKIIb6OglA9HvG7XdM4WO5xojWhGnB e2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209524;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=e7SgMagTj0KzNfQID209UAiku5Vv3G7zNV+yggrUOg0=;
 b=Ew+b/YKs8kx7BkXCAj0i4MlXqoZ2AWq5VKfYj0Anc0b/qiUpfrwMux6D1Qyn40jisZ
 Rb4EmNjQiDzRlMPVzEgy3jC6MBfCiK70jA+b8dT/FKCMnl4zak4syhDOX4ih9k1z0LZN
 i+y6AjnMxEBac2WhLAAMrlxVOFqi/8wieGhhh3dPVj9OYxB+GN6dnRSfMo792BssGdYA
 o1rqqNeCVZ3UvFiMOKMwDuwGp82JmEWBrjPYroyfq9iRVVwLbpnSP3BflnhCXBXbA7cS
 ZzaQNRApre3d/pYSgSou04EXqBAN3MTx1TBOwgGSGrA0w5xZyDZqvHH1NGZGj7El04+k 13IA==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687209524;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=e7SgMagTj0KzNfQID209UAiku5Vv3G7zNV+yggrUOg0=;
 b=tnMfLNKBqdAppzTDzen+nISXF+7zLhHNYWQb7OCNkxdOzGrSO2c35RA972mfouTBzA
 bFgCMbKzliAdxQM1PscO6XLaGolVQm1yNZ3uUXSVzFr+rR7hXLbbEE+chqY3mOo9wTYr
 aLYBALR5LOF9cbisSX1wvpPXKrRdlMoNSMvqdpxgDNoUVj/68dpo8A3JAKA1XVxB6PrU
 Brw0yaPJWcO0lggtGTLy6SYdWZzobHjda1UYvbRqKUNJVGR7THmodrnrP++iW+1hpzvg
 VXW9QAiFA5tkz1Q+q0Zh+UDjpdqAePj6TJ/jKMLz6VA/A9qxlg2o638P/BfnfhSo0V4h DQbA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687209524;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=e7SgMagTj0KzNfQID209UAiku5Vv3G7zNV+yggrUOg0=;
 b=yvRWX6/xx1vRUETU4+aQN4AZUBe951mXyeNy1E+9TrEe/RAbSDFqU8p1dKwDt8G2aX
 7tZhIOxKcytpoqWrLYCQ==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Date: Mon, 19 Jun 2023 23:18:25 +0200
Message-id: <20230619211827.707054-4-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230619211827.707054-1-beanhuo@iokpp.de>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 81.169.146.170
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=113
 mlxlogscore=698 unknownsenderscore=20 phishscore=0 priorityscore=120
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306190196
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v2 3/5] fs/ocfs2: No need to check return	value
 of block_commit_write()
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
From: Bean Huo via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bean Huo <beanhuo@iokpp.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-RZG-CLASS-ID: mo02
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1EQ33bneoxgmq7ABeEwyjghc0WGLJ+05px4XK4px0+bSzE8qij5Q="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: uW23cCM5oRbivJajXLuleN3zV-bBRM0c
X-Proofpoint-ORIG-GUID: uW23cCM5oRbivJajXLuleN3zV-bBRM0c
X-Mailman-Approved-At: Tue, 20 Jun 2023 14:56:20 +0000
Reporting-Meta:
 AAE2l0QuAGczG5HmpIzJGiddfquCRpGjN6APR4P+p/bGHofp+6nKdcOaqQ/xiX4L
 nPJ7am5WrsktH2G5FLxhU9BLWYBuvLtmF4j+uvvYqbU6ZCQYmfLgyHwccbWWc8cU
 MdzUQ2G3ptK2rZI2X/dAQwFF/wTAc4nAMk5JCcrSaxvIpmovJutxIb34lQstjk4h
 sLS2YDhCwnCsrBUtymxTH1ecOzj4JhEEszwXPyOP1IeZfb6dMDobWkW+kaNvTB6h
 bJIiP6yO8uCrXwUZ7HAYys1Tt4Tw8i2ytb217PUOgZSFlQt6A3YO1PtiHIy96wym
 nGz6emngK572ru4ZnaybXY4Jx2moUKNmpxrgTfE9ikgHCu2NVVKriZ82w6mCZOwU
 /A+X2NaUWuo7S3S4+qt8sKQsIezhZGyTH7wwj3iYFJITPvv5WNJpYWYiY6+d7FRz
 mbUSS9hJTJGlEyisQ6rj2CZZm2NXeIHj27ggztIk0veGt3At34NP5maQMfmicsQm
 211N+cv90SqChBOi8FRF2bApUqISOcv5EGCG82OBKtSj

From: Bean Huo <beanhuo@micron.com>

Remove unnecessary check on the return value of block_commit_write(),
because it always returns 0.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index efb09de4343d..39d8dbb26bb3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -808,12 +808,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 
 
 		/* must not update i_size! */
-		ret = block_commit_write(page, block_start + 1,
-					 block_start + 1);
-		if (ret < 0)
-			mlog_errno(ret);
-		else
-			ret = 0;
+		block_commit_write(page, block_start + 1, block_start + 1);
 	}
 
 	/*
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
