Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81776EB64D8
	for <ocfs2-devel@archiver.kernel.org>; Tue, 20 Jun 2023 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oURmt/LRkP4yH6j4UEw6xjqmGMjT8OvR83w5KddwcEg=;
 b=Z7TkySm67+q+hI1jtJ6hp34OibbMYikMUrlT/KHZFTc4BcSFxkQ+4oUEk2UNP7NPwsWDC1InleSn
   Xc9uQx5pBJq8QflbHY3bJ4xQt688xvRtralPSQpkNecCuTRkagvssXeNUXF31BvRXNxepmmlAEV+
   6Npb8ss6i17hsXdTeof0Vk12qe6JeFJQN7AhRFGDISbv2gfkFG3lrc8lIB6RR0NmtrwpDnBSxv1g
   J9g6ZSfh18DlaDyqLlHlZVN+NQznkxxs6rD0/qVlcyUF8LZmb0x2IXduQYvApm7XAwK7o7KioPB7
   LluLmOOyaSzWfL+bvcnuOre0UBcow0IgVUS3Tg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=oURmt/LRkP4yH6j4UEw6xjqmGMjT8OvR83w5KddwcEg=;
 b=I4EI02GCM+nmzii9iuosPZCyyWOVoAyPL8YWlJnEUn3rSqbcOp98mBmr3C/h16U6825Y+XsVwV+k
   NTUCAOEiT8MSC8+RFlNuJSgUMqICE2dMZEP3gv/Po4m1uWZyeyveD9Z8ebEMCrCaZjIv5Dod+9ko
   BIUfGsLN4wYER5QjMlOAyLGFOFt1M7Gh72oqHgO/n6idg8xYwEjaaOYftB/iZTzcKfOl+7pJgx6S
   Qgy+F0O2e8oIOa9dr5ne7bCc17Q3gnjp3QaJoVebW9MVN2bNyyCETxhWg4REhi6J5be6WYwwt3eW
   9l04HuXJ/gxLJRoRfiieRmaaOPAHjBp9rp2K/g==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWJ0054WWWQT600@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 20 Jun 2023 12:19:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
 Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
 Sender:Reply-To:Content-ID:Content-Description;
 bh=E5QUUBOujBKv+gztbLya39h7W7rLwvJjpjCrvA62fL4=; b=q8pPW/CMb3NPPRXd2htA4UuS5y
 ORv47SxAac/b008gU7UOTJSUHz6GNsDktaLvZdBjtYGyvQf1qCJHQ1D13KQRyhl3jXXCSnUzSJ9e7
 v/XlVE5EPNMthDD3tNm0b5WO7yFo6hIXfgREbx9redDW9VbbJvohyhFmg7D3DC41P1MjxbyAarlUg
 VcQONfFztZNqUSpyFbQFknU7kCE2bQkLqLVrPdcXgDFBoSpQ/8eH6BxX+7wZCS/HnRMxgmrLz/e26
 pCz16eRyByMQ/btJ6S/6A8A37hD/AVGA/XXhAQL0Z+L3JVXIDMNMiO2b28Pu3tGtTIk46r61tRg79
 9IfM+kZg==;
Date: Tue, 20 Jun 2023 13:19:00 +0100
To: Bean Huo <huobean@gmail.com>
Message-id: <ZJGZNGyIhJEeYagR@casper.infradead.org>
References: <20230619211827.707054-1-beanhuo@iokpp.de>
 <20230619211827.707054-2-beanhuo@iokpp.de>
 <ZJE6Nf6XmeHIlFJI@casper.infradead.org>
 <9513017b07522373d9e886478f889867b7cae54d.camel@gmail.com>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <9513017b07522373d9e886478f889867b7cae54d.camel@gmail.com>
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10746
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 suspectscore=0 spamscore=0 priorityscore=260 impostorscore=0
 lowpriorityscore=0 mlxlogscore=685 clxscore=201 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306200110 domainage_hfrom=8757
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, beanhuo@micron.com, adilger.kernel@dilger.ca,
 viro@zeniv.linux.org.uk, jack@suse.com, Bean Huo <beanhuo@iokpp.de>,
 tytso@mit.edu, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2 1/5] fs/buffer: clean up	block_commit_write
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
From: Matthew Wilcox via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Matthew Wilcox <willy@infradead.org>
Content-type: text/plain; charset="iso-8859-1"
Content-transfer-encoding: quoted-printable
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: WBq86gzZZxyAmqLL1jhtMMWc7OFSd8eR
X-Proofpoint-ORIG-GUID: WBq86gzZZxyAmqLL1jhtMMWc7OFSd8eR
Reporting-Meta:
 AAE2l0QuAGczG5HmpIzJGiddfquCRpGjN6APR4P+p/bGHofp+6nKdcOaqQ/xiX4L
 nPJ7am5WrsktH2G5FLw7589LWYBuvLtmF4hVX+KH//cJqXHhXRQg6rO4Buw6W0Fb
 uqbPGUOkl5MfnXzMqEnAqV1l7tN3oplNZdLqF3iG7oqSLrkxqKJ2Vdhfl72U4236
 yArvh8kZDDnfDQstND9x0W7nzi5HdPbKkEqPgLFSqUsuS+hye/kPoswtxRXY9brW
 6Kr8szKj1yVsNDT3trQMe6I/CRyNuNlH+un6L2cExz4NUrTuiN6EwwM2v+8k9lEB
 6wZa87Sd8Pq6VytVaJ5OLZGDuBn2JIcJ3gzPB7BgHhbRn8vIOMnC0C4FSBcOPkP4
 9NK9vPy5MhJEp1RAVdHeVhetiE3TH6ocmhZRN/wby1exVTcE9/yUzqWep1cpypI8
 Wim2VGlsB+yoehF7iFlIXdJvw/OUbO/mMuEVGh6oWrgTo8xNGvnd2gaUzaxKAd3F
 IjgOAy1ysrL9HHtUXVuP56T+cmeEI1jyiXmfTaNq1oMI

On Tue, Jun 20, 2023 at 12:57:11PM +0200, Bean Huo wrote:
> On Tue, 2023-06-20 at 06:33 +0100, Matthew Wilcox wrote:
> > You're going to need to redo these patches, I'm afraid.=A0 A series of
> > patches I wrote just went in that convert __block_commit_write (but
> > not block_commit_write) to take a folio instead of a page.
> =

> Do you know which git repo merged with your patches? =


They're in git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
It's usually easiest to just work against
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
