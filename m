Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDDFFC7EE23
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 06:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RLj+SRdNfqrwxH7NZNVnHFk/XTucssBr8Jb4NvLKJ/Y=;
 b=jktVUxt3WfGHLe97CBX+QJ0kTOVD90y0/k0Qln8I8ct9SmO0ykaFWb248f/7JiDW2D7oVjkk15ih
   OCzyF5SQOH6F6yRNwdsYhvBph0UQZYKDBSnXR3ZrO8MUgEyM5U9cYlZwSy/cfWfyTrj/1KzR+zkl
   7lNPPYo/n6bBrx0La7FHlgBbqL5WHfvX5nphqRRwwuPzHw9Mw7UBm8Ivg5OxmwSWA9aGOd7NVW8I
   8tLu2KFDCoErWq+C9u5WVB+GtCxSLC9vwdzPFp1WtgzrdaYgVTjpWZzTXwRX8KB7zpN3VyeTPmkF
   SXxgEQFanh3KWENSkYsu+tpkDueu+6u7U//T6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=RLj+SRdNfqrwxH7NZNVnHFk/XTucssBr8Jb4NvLKJ/Y=;
 b=APFvAz41JH8zkdpHJlQsz6MYWVTIPcJ2lgMDq3M7GrDuDVrFv19i2L/XHQdthvdmiT593vy/t1DI
   75mZrFVX6asDueHfNvUJCZPZuYeE+nG9l98ZQCFtsYJnMbSLYyqX9XiRVJC6XuhNYpbspjiqwh56
   TCUrX1HY2ttl3air5N1jTE6sKNKWmXrpiDe+pdTSqq0VmT5nLf0cGDCNhb+gEHj5F+xJ09WoNHOf
   +1FV7EFhs63asnZEHS7PY6GBwQcujhzKQ/41u6kZqiy7JXgXdI0aMvCcSF5d0U++hYrliHMOzF0l
   YS5SKUTXprpdCCo0t0W0CLm0O+T1q6mkkcKU+Q==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV1002OBRCE8300@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 06:29:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1684736924;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=L51D923F/Qnr60svKwlOplic/YuXek4iXgzeRvfwk/0=;
 b=TMFGOJLQaUCU1I+CNANRQ3NttgpYIiYzMNw0oLGauglsNo34TFFAmC7+rFMNCDPNOpV0go
 XX+k0liBy9uOG8gJgS4u1dSTZ9o3NJ5dVQk6dtRaPdORHOSDqHIFIfJc1JLyovvJ35K8vr
 fQmdFkDMJeOSQvvZNYmQekbT/gJm45s=
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd,
 Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE,
 United Kingdom. Registered in England and Wales under Company Registration No.
 3798903
In-reply-to: <376ab23b-52d0-d7fd-2dd9-414cbb474e01@linux.alibaba.com>
References: <376ab23b-52d0-d7fd-2dd9-414cbb474e01@linux.alibaba.com>
 <20230520000049.2226926-1-dhowells@redhat.com>
 <20230520000049.2226926-23-dhowells@redhat.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
MIME-version: 1.0
Content-id: <2362050.1684736916.1@warthog.procyon.org.uk>
Date: Mon, 22 May 2023 07:28:36 +0100
Message-id: <2362051.1684736916@warthog.procyon.org.uk>
X-Source-IP: 170.10.129.124
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Hillf Danton <hdanton@sina.com>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@redhat.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>,
 linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-mm@kvack.org,
 linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 Jason Gunthorpe <jgg@nvidia.com>, linux-fsdevel@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v21 22/30] ocfs2: Provide a splice-read	stub
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
From: David Howells via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: David Howells <dhowells@redhat.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MC-Unique: _JqmLVPHOXevZRe0HvSLeg-1
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-SPF-VenPass: Allowed
X-ServerName: us-smtp-delivery-124.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:107.21.15.141 ip4:108.177.8.0/21
 ip4:128.17.0.0/20 ip4:128.17.128.0/20 ip4:128.17.192.0/20 ip4:128.17.64.0/20
 ip4:128.245.0.0/20 ip4:128.245.64.0/20 ip4:13.110.208.0/21 ip4:13.110.216.0/22
 ip4:13.110.224.0/20 ip4:13.111.0.0/16 ip4:136.147.128.0/20
 ip4:136.147.176.0/20 ip4:148.105.8.0/21 ip4:149.72.0.0/16 ip4:159.183.0.0/16
 include:spf1.redhat.com -all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: YQrPFG8zczqiz4bmBirVtoI40H0QU_1Q
X-Proofpoint-GUID: YQrPFG8zczqiz4bmBirVtoI40H0QU_1Q
Reporting-Meta:
 AAHwq37idYvwFadZzEtyenXv37wh+ku8BryD23ne6AN7GRNEMR2Jy0jOnKraBHpX
 f0i9AjM+MnmW+L6ygF8/iSTtTzg/q63nHqGNbejxmkhtYsmugAxRe6lIbgSV8yqs
 0X2wFdP1P0qwV1B6xz1zuyak/Lik60IwinLWe9KqaCGqa4N4qyLNF+9WAQlnpdQV
 KZD/dybkSd+lByKjSMS7Zs9vi/eCdddJUGvNXntUJjYpjZvbzzAPxZHTojqXyeP8
 Prx9uBjFmsR6s/9K9au3Pbwcqr6L8PEGLGZ7eUZAeViHPyCe15mzNYAgblLsHA01
 tG4PdAKatAXhXqCE9m2MtxvHHUG4wylX/DG2dFp8jY2qZ56a7edbKr1cfiS8/bOw
 SnbRkRKd5caEClzpgaQaSnC/2POce2tyS2NoTgJtK5RWnTzxZzPIjI2pzEVxB2ez
 l2au0KiJVq5J1mwhtbwVuLuD1Sv6kWcWm4CaKU8S+Fwyci/9C/ChfX9qWiBTJMVa
 QI59TUOqkDe12ZTXgHCgdn0psBHmGIEcZAO0LYBwJuGM

Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> Don't see direct IO logic now. Am I missing something?

See that patch description ;-)

    Provide a splice_read stub for ocfs2.  This emits trace lines and does an
    atime lock/update before calling filemap_splice_read().  Splicing from
    direct I/O is handled by the caller.

David


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
