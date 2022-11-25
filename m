Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009A1C4708A
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5EXq05zlPH7dotHt35fPL3K2oiq5WAIuR2gBrgZ5WxY=;
 b=kYXpYyKqi0rIdyB0mO2RlKvZXF/Obkg5B+lrCP2ctPD4XPMsEKGIF+Pl5t5tWOjogvLFKgaLMTnP
   U2TpRKBv4/GfKZ+LfVmE2dZg/9k4b5EBQQwptpa3vsSTUXdlrYDu6A+KytZ4InPVYUPuWNjQeILl
   s76z4UhIZnPnoW3zAMa/3e6mFm4krRPC5lJpZJfziKwWkD0AvnkZS5biuFMYvPHeXe3HAjfGfauM
   nre14MQIyfq8rYNUQgT0EUw/JAKKY+D6q0hj+LCOXyfEjifCXV8256xeAt2OcE2t4CsPz9VqapzN
   55G/WLDQSaKV+6BrOb1gIOMAG4gKeclSsORxzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=5EXq05zlPH7dotHt35fPL3K2oiq5WAIuR2gBrgZ5WxY=;
 b=kANEvDrKvgnHpVWOxPqSa2+d5JbFFVoD6l9CpAmyOxoxPzOG+Csc7TW4QKgrP7pXI+sNCBwQoQ5V
   sUp/hvjcnWrDQAlNshxgX8z/P6SvuNoHHeh0Qw9D+n+Tdj4EiriegTAjoezhj+4ZoiEUMg/rzKh+
   Clud7s7hgunr9RfCalrj3l0V1EW3AVvHWjgAOpUrJUOWQ8ushaMMgwwwt9t6k6vRRnu6L3xMR17w
   PFjupLy0NBPUkZehGbfYQFn+TDewW8ECIBGDtkE/bkNY0SBezPpgQp0XIjQMWnxehsUmB6gvbSRu
   XvIwb6VXPDaZC4x533t7/NdVvIsiiK5z7kIwhQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00AYEVZ3YL70@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=x53sQaWDa/88sDZr4eyy32ZPwwt0aIb86EtvxNAGN44=; b=FgIlSpJUVdmZH0PghTbL44P7IF
 e4NY5MC1spnQ/Hghs2BPEnAn4l+90NGdQnegTxnvF3OJ+U61eJwM1xO7mu1dExG7v6tzYFJlIwp6P
 B2aUL8HMJfhwXPEFKGEUx8W81rpFniQnI/SO1y7EbgaIaJZ1BUdY5gveE/1N4GNXa8B97uvPu85K6
 Yklhfru9ymFK8ftcM08F8KvpHHcaOQRkbEAd2Tsqc4ddBcwjQEZAIlZg7vNI/YdzW+wA2axEbhN4Z
 espCpyFT59uiQWc205hVxBxnTMNyu5Rhgwc6LnCyra/HjzGVoTTOmo0NKot9JbtDIoan182Jla8Wi
 UlV/To0w==;
Date: Fri, 25 Nov 2022 16:44:27 +0000
To: Jeff Layton <jlayton@kernel.org>
Message-id: <Y4Dw65Nzt4bX9esd@ZenIV>
References: <20221120210004.381842-1-jlayton@kernel.org>
 <Y4A6/ozhUncxbimi@ZenIV>
 <1d474f53670771f324745f597ec94b63a006d687.camel@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <1d474f53670771f324745f597ec94b63a006d687.camel@kernel.org>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10542
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 adultscore=0 clxscore=166 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=85 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250130
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
 linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 Xiubo Li <xiubli@redhat.com>,
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
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: Z-WXpuzE4dIa_EHxpnS4_NCwVxDprukh
X-Proofpoint-ORIG-GUID: Z-WXpuzE4dIa_EHxpnS4_NCwVxDprukh
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAHQhWLkpXgn2HgFLftQcpD/xmEqArfO+3rnLPhRt3f/I+r1TiB2UzVAvrw6mWSB
 IR54K932h1sGGgcfB3iZ33lH5MmxOM/Oz2wr0wFOEcp7kTHKJXuRgb51tkVfNh7t
 zt4rPl4G/Bnk6oLksAOi6kkuYQKhlvGurGloxqfHXITgsHEAewT9Up/Awn3Vxr7O
 8HyPJBElozCYcQFFOWgx6Lzt6vKalhQnNC0ri2JKzOFqgj1iB/UJ5ecQQFIgZjt/
 6WOPX6R35FwgkEJtPBGPMqAfRNAgiz41+n9SlYTYHd2md19331St6EMt/1UZ6ldl
 uFUssSdVTuY0izighz+95mh7j1hfKPwti0yLhA18DdU08uhn2ERagryH4YD2EMbO
 tUp4x3swBrQ61eVJE71fGfR2Xnkuq+PHx/wn1ZDc3R1kBXKswFEjlMdrYuvOGRWV
 JNBzgqaQtbuwgVxb8rDALwhnsvZIDe+PHli2Xat+1wJvyihiWBSNhUZN8sw7I/fC
 akdCdRJjQJX2uS/dNn+KO06bh1gTzu7K5DKcTSCTT+z7

On Fri, Nov 25, 2022 at 08:23:45AM -0500, Jeff Layton wrote:

> I left it in fs.h for now. Some of the file_operations prototypes need
> that typedef, and I figure that anyone who is including filelock.h will
> almost certainly need to include fs.h anyway. We could move it into a
> separate header too, but it's probably not worth it.
> 
> HCH mentioned years ago though that we should just get rid of fl_owner_t
> altogether and just use 'void *'. I didn't do it at the time because I
> was focused on other changes, but this might be a good time to change
> it.

Might be...

> > > +extern void show_fd_locks(struct seq_file *f,
> > > +			 struct file *filp, struct files_struct *files);
> > 
> > If anything, that would be better off as fl_owner_t...  Again, a separate
> > patch.
> 
> I'm not sure what you mean here. This prototype hasn't changed, and is
> only called from procfs.

Take a look at that function and its caller.  The use of 'files' argument there
is (and can be) only as an opaque pointer to be compared to ->fl_owner; at that
point it might be pointing to freed memory, for all we know (and give false
positives if already reused).

TBH, I'd never been able to finish the audit of files_struct pointers passed
into locks subsystem; there definitely are moments when code from fs/locks.c
is dealing with pointers to already freed instances - show_fd_locks() at the
very least.  They are not dereferenced, but beyond that...

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
