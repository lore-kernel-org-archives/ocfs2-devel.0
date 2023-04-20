Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8323EC7618E
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Apr 2023 20:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=m/JtptduGN8wpmh/z+E21U+pAUjtgL06rxqFRpx603Q=;
 b=YrPVTGTu8wXwd1zf0dMeKJZyRdO+mYjWlKGdimd3Jserdx2RbgC2P+LWQTgAXTm709MkqUxL13uc
   qo+BRVbziY1uRlhQw2Hv+1ESmVekDhhpwlsiWRb08mWBYdR2hGnZXeFM/FryJo1nXBSD0xwWYzag
   xG9jphPWrOBetnkQknhb1glpOIYDmxDGwRIAycPTlusdNfrLzaZB51yFSDXbL6xx/p5/KJratACm
   0DteMk7vybDvvFmteobFR/UyCP1E7CAvmTgeMYR38/4Ww2H5t7vBVivTuLC6pA1NwYO1kfK748qJ
   ltkGPnZGiBZ03QVXbvUBa6xs6SxsHTazYevS+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=m/JtptduGN8wpmh/z+E21U+pAUjtgL06rxqFRpx603Q=;
 b=ucle53tRCHARsa7YhfktY0BcfQqrKELbU7lnlCbeNO8Nxcfk70qtaoV7DdQ04g+jDo8YJPCp8Dfv
   Ze3Zdg32EYafqBQw5ETHWO+/XsEYmxZlfVfIsoE7kJ2IdT7PdRhmcMM8JSw7itaFQ6PPW85PjzHW
   GUfLEP4nrwJJjziqukIYdkmng6OP3GX2WRxUCTSfvpFpYfDTo757wrW4N8DnvNOxeRxRpLLDjZ0b
   3ieEj7dk9IwQq8vFDW/kF+5DKrxlt/s4xx7ZHxpWcQjoBjoYleLsGHw3yCM1LrbIu7ZWBTzXHI7w
   fIrBNyc990HRwq0Vnd+6w5P4jpGbnsnhgVBCBg==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230407 64bit (built Apr  7
 2023))
 with ESMTPS id <0RTF00JCXLT6MH10@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Apr 2023 20:48:42 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=LKc/fJIYHijdEIglTa+FsQbwIJmZsw0Xj352C7shrQc=; b=c576q9RTF8ZOJFOjJt76wqaF7k
 KNrWZWen1S3BZtctmbzufl1uJudkXd5qXeqnez681d110Imr0U34RdSedS3pJYU/tHUsMwmFR9MnA
 ah1YgBjFftU5rAM7E3AgSWb7ZR5mAGzpjeiOq3WVU3BfKQ1/sZTOgHYcXLdl8iAhCID6PA7B2asLk
 UqFlrSMX0e36DBXO57QBnP8qm3Va+tQWuhDXO0gD5x0C+VKDYf1Tr11Tmg9T2WF/KQfyr9zZdrpKm
 vhjbggVCT9HwtBOnr8N7b2R0Ugi2Sfq+JLGxQ7+gcSra2cMVvlVAKjsV20DZJPoBwwkpRNzcpdARq
 70zkCJKg==;
Date: Thu, 20 Apr 2023 21:48:01 +0100
To: Christian Brauner <brauner@kernel.org>
Message-id: <20230420204801.GO3390869@ZenIV>
References: <20230417205631.1956027-1-arnd@kernel.org>
 <20230418-fortgehen-inkubationszeit-5d3db3f0c2b1@brauner>
 <7555eaf9-b195-5189-3928-c7292e4a0ba5@linux.alibaba.com>
 <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230418-vielmehr-nominieren-7f2adb0f6703@brauner>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10686
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 phishscore=0 clxscore=19 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 priorityscore=108
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304200174
Cc: Arnd Bergmann <arnd@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: reduce ioctl stack usage
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: mnLcLQfvOWctuE7eK8AXYRrgHjbRxm_g
X-Proofpoint-ORIG-GUID: mnLcLQfvOWctuE7eK8AXYRrgHjbRxm_g
Reporting-Meta:
 AAE5ho7KE8AQSRK48FrKABBjouFtk6Z0pVX2iy8Db7vFvqNAD67yKXZRWxt9GINX
 MUi7Ju/gfTbI8MW/MHzSb4FL3JhEjN79Q0cjbwozJgu8Jg5UpjC+eJDcZlqg2XO+
 n2Imi/n/CQfJLO4Y0XkeJB8juKbVPRzfhNvDuuVqFiI5CTz7oYbcvbRhMbsuekRe
 1vIyvMlNoCT6a9Po1WdGDv1b3aRt14AGZULRGTW2hfYIKE2XL5uEbgQ/jZfKFU5G
 nIvW6zKf8ju/5x1kpBfD6unq6DopuG6tJwpj0HjTT5Xx20KAfhRrHInJQZoJ/5w6
 glnhWmislgaLbX/B67+cb03PZiaY8d5JJ1jzMJaYdW9uZLuuLYJmR85gSnFHajZx
 UR+iR6w59TbbS1s+yIqiuK5p08qQ0kFyHV7wsW2EGB2t2k+y9MpezvyrYpImvh57
 KGnEAMy3rdeUJF/WQD+NZgwj4y2WwclMFbbNzuY0Ropn54TMyZPrvc9t4rIjOTUi
 oZa8iMfijgQSLZYEEBoWeLTzbeNvpPIAo2Rrf5x9wto=

On Tue, Apr 18, 2023 at 02:56:38PM +0200, Christian Brauner wrote:
> On Tue, Apr 18, 2023 at 05:37:06PM +0800, Joseph Qi wrote:
> > Andrew picked ocfs2 patches into -mm tree before.
> 
> Yup and that's fine obviously, but this belongs to fs/ and we're aiming
> to take fs/ stuff through the dedicated fs trees going forward.

Er...  Assuming that there *is* an active fs tree for filesystem
in question.  Do you really want dedicated e.g. affs, adfs, etc.
git trees - one for each filesystem in there?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
