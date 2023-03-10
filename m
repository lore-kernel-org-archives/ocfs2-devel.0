Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14200C6FA99
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Mar 2023 06:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZjZ0zJnJ2u8ooVCjczZiQ4k9ytXxiBgat7WF9TU1Bzg=;
 b=CGgPQq/k0lVhI+UGBn/tsZSXc779ZV1Vsek/HWOlJJR1NvqSU6zmLct67KElDrRnRQjM3TL5Unu0
   jZ26TulttByTd/yk9iMNdJtACleivepHm5xVPEdVzdAiXaUkiFRFU0VbNX45jYQ+8XbrAiPKwrD0
   LybvpMgGlOVZqKTJypfBjP4QE3OAPhm/GxIq8w6QwDfENLBMtkfmSJl9dVeQ5GiMTdQ7ijVDg+bX
   /G93VhjTuLbmp6lUIuNUy2ox3pZRWQ+kOuolJz4sC3kOjhQ6WN5hOjQxN95sHlqk4imjisgtku9f
   X5kVAzE61iffwJrzO6X+4oGGlPyNq43bOF90jQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZjZ0zJnJ2u8ooVCjczZiQ4k9ytXxiBgat7WF9TU1Bzg=;
 b=JPEtLFNQHLw3FwuqRNvuPXAXOPb7/U/RvFUbhS6tSe6HeIDR6ldpccCxXIUeQaM4wJqNsgklZxzJ
   62/stoz2yGPT85Hv+QbC6fz36jNfXL5BevNNdmtxGA2DvRh2oE/GnqsX5nz5Ge249YALkYPth7pQ
   J8o5b7U115rKLMGM9jtGAV7isld7+0IErHAWyyGtQ/LX8yeU5jE2WbMTLc6KqymOos+DwzY3B2XA
   G4SsCtJBQ1LN7pzGnyLVjFQ0eyoyZC2/G32KRHBSUvjatfmYZ8DrT/Hk0+by70RvOgBAZKbLWRUc
   ddm0jDAc/vQu0mFh/u0Gvnryv1SIaWubdgV/mQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRA00NQ8L3Z8X40@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 10 Mar 2023 06:38:23 +0000 (GMT)
Date: Fri, 10 Mar 2023 07:37:56 +0100
To: Al Viro <viro@zeniv.linux.org.uk>
Message-id: <20230310063756.GA13484@lst.de>
References: <20230307143125.27778-1-hch@lst.de>
 <20230307143125.27778-2-hch@lst.de> <20230310035353.GM3390869@ZenIV>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230310035353.GM3390869@ZenIV>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Source-IP: 213.95.11.211
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=225 spamscore=0
 mlxlogscore=259 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100051
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ufs: don't flush page immediately for
 DIRSYNC directories
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
X-Proofpoint-GUID: xsjsho1FfgFY6-xvHRY_6tsbKrNMuCZd
X-Proofpoint-ORIG-GUID: xsjsho1FfgFY6-xvHRY_6tsbKrNMuCZd
Reporting-Meta:
 AAEiEvkYSTqZjXzEMkGbFugRHgmXnsE2/NbBR5fgfYHM0MOJYeo03EsxageXyCeH
 ukqVJxaq3jBQ7fX5dek+Ux9uqaiJeRERJdh3PEOaG5nFwmRhpZ6Ese3z0Ysqi2Nq
 fOf8TdnDtdcUXkERcAfT4Xk2HBC9GZjableKYBQIgU9HrTbSdS7QRs8+FGjYqY3k
 LrqIvUpGWfij6V5QFMSZDDnlJxRFUE0XZOIwA0DYH/T9KGScml5aFNJsAIBlZJR9
 iJpfFgJC+Bv/zOdQ+w5ZiY8GwbydJlPoYwINPJGAlEcbhkGqdH+p1ElcH269NtTp
 m2p4Pbqj7EgsxIaRMZ7/ev6R77UH6o19y4/fe2V5cmIxzl8bIF+3XKH/EXLgRENx
 xcc+o02FdNWaelmMhIEx0tSIE0/UDIARyvTrz7OHOoKHcM0PLecHG8OKtSieqXT8
 unZIvrLRI2KZWkMYrwLQwtb/IX2SY7LW5Jb5alRN/acTKSM4BY/1T9kRzG5sn2na
 WiMFb9d9Ni7tdrIE+E7vfLBa+ZmfYK2fpa0/sC5qjIY=

On Fri, Mar 10, 2023 at 03:53:53AM +0000, Al Viro wrote:
> On Tue, Mar 07, 2023 at 03:31:23PM +0100, Christoph Hellwig wrote:
> > We do not need to writeout modified directory blocks immediately when
> > modifying them while the page is locked. It is enough to do the flush
> > somewhat later which has the added benefit that inode times can be
> > flushed as well. It also allows us to stop depending on
> > write_one_page() function.
> > 
> > Ported from an ext2 patch by Jan Kara.
> 
> Umm...  I'll throw it in ufs pile, I guess (tomorrow - I'll need to
> sort out Fabio's patches in the area as well; IIRC, the latest
> had been in late December).

Well, the three patches really should go together, otherwise we miss
yet another merge window.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
