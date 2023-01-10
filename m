Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C494AC54EBC
	for <ocfs2-devel@archiver.kernel.org>; Tue, 10 Jan 2023 13:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0hGx/ffWbQevsp0VtQ6N4UTVfC30dTtnP9L0goH5b04=;
 b=vDhWK6gDXHk3vS59bBmHTTrncWgI2mPWLuJkPlU4wrUP8hM+/UC/dxTkJNeOj8xIqRezILygvUJ6
   Xxe0aRIM0qgXP5eo5aSJ4NGTg1SiXe7FQNNQi0pWRAqthF4H8cLCpjT/NYrGOZ8vBp7E7RYU3ypb
   L4EXTMFzoYbGb7rgRwzXm76HkUxL5CU3JRnf7G3UYa51ZenO0JnUfbAJw91B3JIMvAcADR+LruXQ
   yRydcqDnFnqA5XnVBz7JzloupbdE4HfTVcdRJwKYbIXEwHoScQRZuwPnjzFUc5zDQKHyE822W/vb
   yFm876HMLqzfGeSQCzpY50dAsUx4aeZfaqRKqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0hGx/ffWbQevsp0VtQ6N4UTVfC30dTtnP9L0goH5b04=;
 b=r79zO7C5E425c0VvnK7NXyQzXGswbTYZg6Xqo3UTqdyYNTF1ObmTUhF9UkUW6iF3Tj1rViFSUcFb
   v0q0f/k2CLArNnop88Vf0jlIDtAHhQppZ3NSlYAScM/sTG+DAyMuUlJLPmSKIPXSXFWQtVFoAe7y
   pIiB+3S7vv/RoQ7mBcMO7h5beT1bEk9yBvfZGLoNp75APf1GBrfFHn/vs1z7LuWqWD3zqiHVmo/4
   vxBG6Sz0WL4yjbbSFpICwrtGwc/146wJFxYRjQTC1PUNXXE2UdAji9xaV/Jur0LKnKV51Va4BZPn
   M0XcsssjdimpRXmrpQcWAkiCHav/O8J+G9OA3g==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO90048VTR1CUB0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 10 Jan 2023 13:06:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1673355976;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Oagt+4vJMZBwYo+UNXn/MG8vqxeNFrHBgtCcArXVT6c=;
 b=J9B94SIbxnl0oE/XF1iLiZ/pxfG9UhvmUFS5xpUxqDUMAKJfxpqumk/XZr7MssvYOcSDwa
 xSmOMO1k5wFEThQsRLQPlW5wQj+M1FlrCn0irK/hj1yWrlqya7okuRchYwsOvdaBGNvoDk
 tQcuLbbpyP9cf6J1FdS1G5nshzgF9wA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1673355976;
 h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
 cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Oagt+4vJMZBwYo+UNXn/MG8vqxeNFrHBgtCcArXVT6c=;
 b=QJYz3Rx4bQN8uaOfKuCv7ws5nYtLdlYJZpH7vCk2H1VJ5TaHkPwSItV/3ew5XEFL8w24Qx
 N7mZks4HQ0kYT3CA==
Date: Tue, 10 Jan 2023 14:00:42 +0100
To: Christoph Hellwig <hch@lst.de>
Message-id: <20230110130042.GA11562@suse.cz>
References: <20230108165645.381077-1-hch@lst.de>
 <20230109195309.GU11562@twin.jikos.cz> <20230110081653.GA11947@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230110081653.GA11947@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Source-IP: 195.135.220.29
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10585
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=842
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=126 impostorscore=0 bulkscore=0 clxscore=157 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301100080
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] remove write_one_page / folio_write_one
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
From: David Sterba via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: dsterba@suse.cz
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out2.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:137.65.0.0/16 ip4:151.155.28.0/17
 ip4:149.44.0.0/16 ip4:147.2.0.0/16 ip4:164.99.0.0/16 ip4:130.57.0.0/16
 ip4:192.31.114.0/24 ip4:195.135.221.0/24 ip4:195.135.220.0/24
 ip4:69.7.179.0/24 ip4:150.215.214.0/24 include:mailcontrol.com ~all
X-Spam: Clean
X-Proofpoint-GUID: jjGzQBgf81pZixhHT7gUMH05cCQldGN5
X-Proofpoint-ORIG-GUID: jjGzQBgf81pZixhHT7gUMH05cCQldGN5
Reporting-Meta:
 AAE5u2LHjiXUT896q352D28lQTTRS5DLc6zC01MwpZoPJJhJMSql6kpxvAOQTmM/
 cGSAn/NB/OYCALRqQq9WL2MNKLjROeVTh33l9XWP5TkaTH4MN1rl2qL5pu2EOWr7
 F/MueGyriQgtWe+vYqTi3SF8jGyjT11RlfhWGQd7vNtEuKj1W9JS69Fs7H/p+QTu
 gBOZXUJE18zWqqQOpS5t2WFjuE8GLgRqOsyAnYmAqRFkMTbKi3OmidFoqVyNnHa9
 8BIa7bxfgpbPHkq0uEtkCzHnROsSGP57PIJdMhlgJhDkK+X0xluEiNwlW2/5Aguf
 k5mGzFKLSYRozqS0EAfs2nr4EEYwtXu4VsZAaPYmNw0sB9rV4d1LgeI4X5zopHmD
 2sL8pon6daZsO5nphsbkkwqCrAqjuecdeATZS/vg0kKZU9yiYuPLM/d7rhe1+0md
 KQAvJ5qBHJTorpIhfySePhaSBWbog9f3o4sl/aRmiIct0chOndtabXLv0zeScV6f
 mHr+stB1B0FcBvxeFGOjxP3BSUN4zAdYNOeOstA2JAA=

On Tue, Jan 10, 2023 at 09:16:53AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 09, 2023 at 08:53:09PM +0100, David Sterba wrote:
> > The btrfs patches were sent separately some time ago, now merged to
> > misc-next with updated changelogs and with the suggested switch to folio
> > API in the 2nd patch.
> 
> Yes, 7 weeks ago to be exact.  I wish we could just feed everything
> together now that we've missed the previous merge window, as that
> makes patch juggling for Andrew and Matthew a lot simpler.

The patches are not fixes so they should wait for the next merge window.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
