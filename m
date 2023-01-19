Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACD07C38142
	for <ocfs2-devel@archiver.kernel.org>; Thu, 19 Jan 2023 05:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9jita/WpcnDi3UDcVbrkP9B7229UEHKgPPxpe6j6d0A=;
 b=nv0Pa0WArv+n2kDXHNIa8LfTWiEfs7PLbtsYSkpko26Ie1sFznLbMFrhI7O9ehrwodgMato9XqJE
   Ct5dKpntI71CiAGAfnZPU/abHEvI94MfuK6S4i/GFSRq7QQktyJWSrXoDWBOLt1NFUmEmCxtXReE
   ZxpNSiQ0Xi5wadVbKyZ/xugtOk84XUZe0qFzbNpGopVMx/Y4hQD6efLqoMcaHxPDEaNA1WgI2/KS
   vo0Ihi8TEokcX+Kk6oeIo59TTXUVeYBEADBPNcxWflr1uzwoaZM8gF50v5rzhlIAn6C+lzXLgKhO
   w0BKtqWiSXSjQOjY91LHqofPbFZGzUySQdqILw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9jita/WpcnDi3UDcVbrkP9B7229UEHKgPPxpe6j6d0A=;
 b=oIKAquxae7KXUHJ99OWfqATwfE3dPWqFqPzeY6LR2RzKuaMVd622r1D+YP4GQsslaO80bFK75rap
   U+8YxlWG+vbvfH6d8EBaB1GBn1NbkCPMKbzQxAnU9kuRy5lYvhL9BN90szlhFSdkA3c9JghUlzyi
   Jd+1SYFmlXiMQcCj4C2YBWIWw0C3YnC2GdprjfenW9zYgqSC0UsT6/1QbWYvNOTbtzVZaINmWklb
   svsakx63R/0MKS+XruL4WPbsayCWMdzXLEgXAVQjnBmodAk6xKOFMUmOVSrHovJtH86XVdX+lE6A
   zEgS12PczURdvbIbIghsNW0ENqHvBK3F+A1ffw==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROP009T8WJWP400@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 19 Jan 2023 05:28:44 +0000 (GMT)
Date: Thu, 19 Jan 2023 06:28:21 +0100
To: Al Viro <viro@zeniv.linux.org.uk>
Message-id: <20230119052821.GA16631@lst.de>
References: <20230118173027.294869-1-hch@lst.de> <Y8hjWSfC8TVCx5Fe@ZenIV>
 <Y8hlrJJZ2uJbZSCv@ZenIV>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <Y8hlrJJZ2uJbZSCv@ZenIV>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=793
 priorityscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 clxscore=68 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190041
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] remove most callers of write_one_page v3
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: verein.lst.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: DZm2kwuS0RMwTxbBJxvvQNmfRF05ZYnO
X-Proofpoint-ORIG-GUID: DZm2kwuS0RMwTxbBJxvvQNmfRF05ZYnO
Reporting-Meta:
 AAHoS3SSMso6fo39DJUjlHub48TjREyu+UV/ntKOQgobTsu/xUeizeCUsHKUmjiH
 X85OtATuGx6HFkTI0CgaSQ2AYhfv9BAILMb/zaRe55zLqTJD+VlY5r/gAeXYwhm/
 nUZ4yHbWY5FiqIKf5SJRTtM/2a0qdjeTRTRznWLT6u6O7PVthyrbJHCzkhXRrSpZ
 UbwJQLfqnBKGWQv4rAyRk1RDefK48AHD1g9W6l8a4fQVzyKKEBjrLG1QkGRjhSnd
 CvbLpym944KydlFqLLw/Y0V1SkAAS+8IM+cPSyGF7++brGmlYGUvNLRr4vBf8vji
 8AQRK67GS0uSQWDdpTO3BvnQ8/c1F3IzBR03pQ68/ZDStj4PKj9bE8zVM4Voerdf
 6RQSAFoGxkUKU8fo4/TRfGU+dpk+qj7t9okfoW6rYgmzZ7jd6oLT25XJQvdoMSwU
 9XJm2HLY5WJelufKwutmvMyaGG5uxqWXTvYVESzluA2JjpcANGjgW45G07JZXtFj
 BT2jkFiXMD+l4WPOojw7jYG71+I0f1OXkaWkoxSLs9nw

On Wed, Jan 18, 2023 at 09:33:32PM +0000, Al Viro wrote:
> BTW, do you have the check for minix_delete_entry() failure when called
> from minix_rename() anywhere in your tree?  I don't see that in this
> series; I'm adding the trivial fix, hopefully that won't end up
> creating conflicts...

Just add it in top of the series, I didn't touch anything that I did
not send out.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
