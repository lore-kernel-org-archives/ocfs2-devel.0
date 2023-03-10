Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E25C64EC4
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 03:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9D/Zg1aRodXGU7lkJ4gZGZuyT0JK2varklOOMg92pF4=;
 b=DP9XpM0mVBoDCTw+rTSjsgyXhEefzWk/ID4mNCKv4hOLLMLt9jH+9wJVubFhgyWH/GYMcdDd6P+D
   HKMaXlU76XyDCdzNJappl6xopdTTwrYU4SnuPt2g5qoXCG9aDCKOU6dXMf4ely8oPtFpozZZvopM
   wyDrIx0jHfy/1K8R9+0jDlI4y9L7zo77bdL6ldUmJfMzzox3zmuPMmyF16h13pkPJ1EZqOr1ym5j
   Wl4la3nzvnl0z9AQhDjFKNkadO+/nf4N4jrMMnOyOF1YfNBXAAJkr0fs2F3Pz9nHcOVZ6XdbsFxX
   vvdLUcH878yaK3aoInLut/afRK5RLikiNgeVWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9D/Zg1aRodXGU7lkJ4gZGZuyT0JK2varklOOMg92pF4=;
 b=uRmjm8PYmkeCjazLvGFAenMdtpS6arUbM9CpdnJULYFHd7mR/c4DeSJmPyocuGwUvEzd7O5ecblw
   Nq7ROBlg4HrCcyujNRwfJxNqLJjxxWhxcAcREI7ruMN9z8y3GPePADRE0hGaNXRmTIP9Ozlryz2O
   N2Rd5bDgM76ft49OlemyRyHROZxFNibPj+I4sF0dd9Eotqdll32OwYRLNaRMkxYBjhLUdBg2alyU
   QUQxtSyGVeBAWh8YMeC7grOjI3bo5FNGoUH3CkN+8F3m47frE8e1ruNO4lYOLz04pHL6jo9pZyN8
   0yHrgqaTV6qcZ5PHSNWq8Wisbcuggl6W8AZWsQ==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA00J0KCIOJ190@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 03:32:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=5nYji9aiOTPkm277QrYAaIqlTmxJJ+NstcSRT3Yv5A4=; b=BlyYntEGWpWNJHstS6q6njadFa
 P58IUANDyb039xyu+2aDp2c7OzdJYDBxQ5K36A+DuuZuUxMwyf+wQEWfkoOhKX//l4UgaNIAhZroj
 raHHfhXFjHkvEhH5SRgjFwVGqN5H037vB9hI2lc0ttLBBrZkpqsiVlRQ+zDDlDn2nXR/ym7JEaTMj
 k6jnj+0wNV9kTXPfzi28opkBB44CtxTJKx85YoHPGh4jQsUxI800+WVVKUEpFmH/vlz+1X4VI7tC3
 aHldI5fbRXyo7CAXw46+xJ66nAVzuZUZqoth8N05jHB92fCaFVa+cWyRpHY1w0o7SEQpAJUAyFnMg
 lssdi5Fg==;
Date: Fri, 10 Mar 2023 03:32:13 +0000
To: Yangtao Li <frank.li@vivo.com>
Message-id: <20230310033213.GG3390869@ZenIV>
References: <20230309152127.41427-1-frank.li@vivo.com>
 <20230309152127.41427-4-frank.li@vivo.com> <20230310031940.GE3390869@ZenIV>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230310031940.GE3390869@ZenIV>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 bulkscore=0 clxscore=187 malwarescore=0 priorityscore=95 adultscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100025
Cc: brauner@kernel.org, tytso@mit.edu, agruenba@redhat.com, chao@kernel.org,
 linux-kernel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 huyue2@coolpad.com, adilger.kernel@dilger.ca, jefflexu@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, xiang@kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 4/6] ext4: convert to use i_blockmask()
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
X-Proofpoint-GUID: ii9nXF7uROA0Zl-nR3B5vDY5EgOv86wm
X-Proofpoint-ORIG-GUID: ii9nXF7uROA0Zl-nR3B5vDY5EgOv86wm
Reporting-Meta:
 AAG0A57xnf5pkVZ7Uo+QZuXJ8KTQU1nPui2pwlWbJ5n7w6iQBx05vmL0w3XC2pwG
 HZ5aa0SvmKBLeVc0g+syBG9khvdbqui1d82IWFqZL4PLCk4zpbjKginSeYAVti6C
 RjkoQ2CHgx3cjBm4h721x1ghvdT9OJGHFGRv9fAD0mZ4rph201/N8Xd5YHNJfLXO
 YoZhBjBK4Qj4YwbSgIIHbOirxIjT+he9Qfvd2Hxt9X7+VEPGRWOTUkjQHP1jYAtt
 Ec293yTUVw/l5SXIDlhi8xGTsDTvtx/6msE8vMt/LDiQ51H7JqcBRJ5ghiiGrWMG
 Zg4GRjvP18DjeND8s9tiA3qE+tau/ljOTfyf/f8Ai4AJjXQbhGfz1v2/vm7ok4KB
 QYLE3MkkYrNNDGrZhoVmwOJahMbyJxmYThXqW0KCGw0wVCtspdrmLWnF6wT8as2t
 8PeeF8aBCw+M5qPXKI/bymJsilqjqUi8otK3Hq8FDYWcZHwgOZp4bA30SsnGBSab
 MjpZVf6Uzb+MjyAZLOapZV6Cm2pZKxaR+vZDr3TkHVch

On Fri, Mar 10, 2023 at 03:19:40AM +0000, Al Viro wrote:
> On Thu, Mar 09, 2023 at 11:21:25PM +0800, Yangtao Li wrote:
> > Use i_blockmask() to simplify code.
> > 
> > Signed-off-by: Yangtao Li <frank.li@vivo.com>
> > ---
> > v3:
> > -none
> > v2:
> > -convert to i_blockmask()
> >  fs/ext4/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index d251d705c276..eec36520e5e9 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -2218,7 +2218,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
> >  {
> >  	struct inode *inode = mpd->inode;
> >  	int err;
> > -	ext4_lblk_t blocks = (i_size_read(inode) + i_blocksize(inode) - 1)
> > +	ext4_lblk_t blocks = (i_size_read(inode) + i_blockmask(inode))
> >  							>> inode->i_blkbits;
> 
> Umm...  That actually asks for DIV_ROUND_UP(i_size_read_inode(), i_blocksize(inode)) -
> compiler should bloody well be able to figure out that division by (1 << n) is
> shift down by n and it's easier to follow that way...

BTW, here the fact that you are adding the mask is misleading - it's true,
but we are not using it as a mask - it's straight arithmetics.

One can do an equivalent code where it would've been used as a mask, but that
would be harder to read -
	(((i_size_read(inode) - 1) | i_blockmask(inode)) + 1) >> inode->i_blkbits
and I doubt anyone wants that kind of puzzles to stumble upon.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
