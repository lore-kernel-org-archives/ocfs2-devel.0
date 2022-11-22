Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5516BC63706
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xpnAwekwA6QFdnUxR++MlY/UU7Z1M1+0G/arRuaqZzw=;
 b=Kmc0yudFd9qjtM28AKlxF/3qKsMqpbjRtylNBvxHVTQLI9O07V5UCuZdS+l2Jt/f9c+okld4RpR6
   sqNykPmyh1PTI8iVXzLVLp2WQqxaw1gkSdG8wyUbiZlY4o2JmGAxIDo3re9bH0FRrkryLfhdcHbx
   wMvr9o2k//VUcjSEuZ87vuRUa8jFhcvLL+livlJrn/B8foxKFMedAYbq0V7HwhX4XCKEGu82tgQA
   gy1RJ7vC/RycChqC23XF8iZmZE7DGd6UgiX8KTC7fJvCqJQAtoXC6YxFceUxgDSKT8rnO7zKhruY
   0Z/P9dTnly62UnVRzl6Crn6PM0TPgKA0PcUWRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xpnAwekwA6QFdnUxR++MlY/UU7Z1M1+0G/arRuaqZzw=;
 b=RT6gGnB1WvtRwx03lXJ5S4rq9UApNynqlayXz9C6emETRSE7UUokcu56yWMjNfEL694h2u0t37Ct
   pb180KPqwqqndpo4hXYu2qTR1XwIYs5t1KD0UQwKy51QiNnqf7+WSxp9JzEnF6DUs47GONLXXjZ1
   sWOD6yJ9YWYesDGzDqINUWx5FaETSgF2B0WIczh2bUVg6ECuDJJ0qvmVpgH/6VfV+tjy/dGwDBkJ
   86gKIMM8f14TZ/rkYVjctP/x7hZzlpywZoFGUz1WetkhV+3wFMTLjnFZEpXvVfavc3j9kHJB6LTM
   1wGiORUUqeaOIcfv7k4yShmhXRrgEG3J8zYQuQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY007S0VYZXT80@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:47 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1669115639; bh=bl116Cg89IGIZVG9NrRKWmlP6ed4aJACzNI0Wp3w7MQ=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
 b=PW904WXq7B5dnjaE/n6/stkLttLw66q95uzaVXXfC57Gr8fGyA50W/Y+6YMHj6/Z6
 C+bp2zR/HpD7AL2kDXCaUnJHLo0QYTjCM7B7srSBYzv9QSoZunuSXqgWz/eURLlX6f
 bkLmFZpbKLyi6RqKREvtIsB+vKfLjAYsE4lMeS50ONpsJGmxbLEBM8TI6eOVtcA0LK
 FmF5vJc1DjzHEZ764Fk6lm5yRoCPsh46VllB8mEkIzIHUVtq1E/Ip3Df/1o0TdNO5Q
 AIsD9dU2QJjYYPKYl3/NasVd/l9SRjkJBU0cAIKGCY06yaw8kwOzVXEKArpk5buENB
 HvI5i9aGVVUAA==
Message-id: <fcc7161712a2c8ff84420477b12b9114195e6624.camel@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Date: Tue, 22 Nov 2022 06:13:54 -0500
In-reply-to: <Y3xHQwM3UiD/SK0K@casper.infradead.org>
References: <20221120210004.381842-1-jlayton@kernel.org>
 <Y3xHQwM3UiD/SK0K@casper.infradead.org>
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37)
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10538
 signatures=596816
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Martin Brandenburg <martin@omnibond.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 linux-xfs@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
 linux-cifs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-afs@lists.infradead.org,
 cluster-devel@redhat.com, Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, devel@lists.orangefs.org,
 Shyam Prasad N <sprasad@microsoft.com>,
 Eric Van Hensbergen <ericvh@gmail.com>, Tom Talpey <tom@talpey.com>,
 linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>, linux-nfs@vger.kernel.org,
 Paulo Alcantara <pc@cjr.nz>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
 Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Chuck Lever <chuck.lever@oracle.com>, Anna Schumaker <anna@kernel.org>,
 Bob Peterson <rpeterso@redhat.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] filelock: move file locking definitions to
 separate header file
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
From: Jeff Layton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Jeff Layton <jlayton@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: aV1hV6PjKgeBjRRaqulKQgQe0RniXyvm
X-Proofpoint-ORIG-GUID: aV1hV6PjKgeBjRRaqulKQgQe0RniXyvm
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAG9ofe1uZIzVLY/EytApz2OUm7+LKfPS4LFKD4SDn1V3O72SA9QzodZjPockSLj
 fgAIglvVGfYPw8v2GDQ6X4/lMIqtgtu7dzhPY92iJ/XDLCDw09iW+9hyNYt9cJo8
 g2MiQcXNhtB4DLmhd7E585O+XpmySrf/7nsuBOO3LSi57x5PMsScYhRvDUurE1Zv
 NAkZBUOiZtM5INLM84QEIq5CJe+BHNuWlhcPp3TqyqUuGIUXcf2+8ESqs4tuFUSN
 rZx5gUWOA6NqrewZ5B+C0/A5AxTAy2Zxd0hnv3ldOm3MPmFIkSm0wo5SicbMgNr7
 XCktBxg2PVrLlPBr75x60xpqW/xEZZ3Ro7DjlOFsWC48V6tf+eSeDCyf/EclIUsd
 LSmCEL0IJZT12Hcvn+giKsPjl0JYljenu0j0wi/+C1h//XKsERp9hp+v5tcP3mK+
 zytdXGJANCciHO6lpI5vE9OvapJSd35EqNWTYw5fUtruo/6LBROW8APfiJTo1s8u
 WonFzsu8iUjlF/13y+uoC6mkAjVwcw3aPhYKM/qHTrYX

On Tue, 2022-11-22 at 03:51 +0000, Matthew Wilcox wrote:
> On Sun, Nov 20, 2022 at 03:59:57PM -0500, Jeff Layton wrote:
> > Move the file locking definitions to a new header file, and add the
> > appropriate #include directives to the source files that need them. By
> > doing this we trim down fs.h a bit and limit the amount of rebuilding
> > that has to be done when we make changes to the file locking APIs.
> 
> I'm in favour of this in general, but I think there's a few implicit
> includes.  Can you create a test.c that only #include
> <linnux/filelock.h> and see if there's anything missing?
> 
> > +	wait_queue_head_t fl_wait;
> > +	struct file *fl_file;
> 
> These two seem undefined at this point.
> 
> > +	struct fasync_struct *	fl_fasync; /* for lease break notifications */
> 
> Likewise.
> 

Yeah, there is quite a bit missing. I think I'll have to add this at the
head of filelock.h:

#include <linux/fs.h>

...as we need several definitions from fs.h for this header.
-- 
Jeff Layton <jlayton@kernel.org>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
