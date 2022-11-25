Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E839BC63708
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hbeMj8TibguXXlsg7H0phxJZYIl3h+U34UCvoxsCYow=;
 b=x5DkcRStLRTgEn9qT4nkSGLfoaIWADHupi5ztmb8NTepaz+n8M4rA1FJ5PmpqZPrsrUm7mLko07d
   nSTQOpR4hHEh4+Q0qfEgZIoe0BI7Z2QJO4GIrQpwkHAyf3ap1w8Jetendr49Q10i+PffsrfDzXdA
   MmCmI2/aUrzhy8c0124Z9YlM1QkaxON7Qs4rUc+aYuV26r7Ghi8Olqvou9QwBkhPEeI9Srm3F9zZ
   3fG/B7inm/ckoPiEvQTW+dfxa8lHutTHYyIQSxBCLbMF0894DYsHS3hOXNRqZYLssV3PX7g1/FBk
   Mb7g1JGZSZjYCUrI+ly/syk2yAOaWVCifAJ8yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hbeMj8TibguXXlsg7H0phxJZYIl3h+U34UCvoxsCYow=;
 b=WzNwNOFKSlHu4n7LgYydnLyVWtK4BJbjB/iRuqhsgm9mAWJB54OkpK1x15B74P3LX430oxBx94bE
   v0lq8kR2SjZhfC9+bWXoYxfd6JwJy4SmUjqkZZexrIvRWD7FNSXysFkNyawWNaHlTfIFXFo9pjgS
   Ts944avJO5w+w0MbI/9le8y9WMH1jXjqKHYblpBY/YHQOPVYR7t6auQnlqcFlrGcLMkvy0CEPyPP
   Sg5SiSrqWwtT7L94C7t5qcPBGw/m7R71EELiU9Dlb0MQtcT3nXO1TsYdTPo2jg2egLNvwzdPFjuX
   tFwDTH5JHknQpw6JyMWxKbWakYqdzbSfrpvqdg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY000GBVZ1LR90@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=f8/x32fER3aRdejEpsCx+wOLDBv/ItD+V8F3NbSrtbc=; b=r01ynWszvCOW0gRReJc0mPmaeT
 4udkpjpGBia+sXIkLIOXBsuaTlBVVkhuppKmpDdjkBhDkp9t+rxXxKEZfC7Fah0vLuWEsX16J14kQ
 iTDi+/xmZDYDDpRiJO3Ln80mvbANCN9dZ1YHac6GOcrRJjA/aE2lJaIL/tDDVCfEUylL4CZlZXZZX
 nbCeFUeaVpnHpD9IQVhtUafE52qEQizDsH/bqXEg2ls1U9f8Vd+QBwZpM706f8WpTgGDI09nTdvx6
 baGfSswMUU47TynqNM8QZmdIAaIBUdKFdNBuvYwagQEw9nbEwfjDKkq/hBZ4WObbqHj0I0Imkq+By
 1qK4U+Ig==;
Date: Fri, 25 Nov 2022 03:34:14 +0000
To: Matthew Wilcox <willy@infradead.org>
Message-id: <Y4A3tmISFIR7ERfE@ZenIV>
References: <20221120210004.381842-1-jlayton@kernel.org>
 <Y3xHQwM3UiD/SK0K@casper.infradead.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <Y3xHQwM3UiD/SK0K@casper.infradead.org>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10541
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=-70 spamscore=0 impostorscore=0 mlxlogscore=755
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250025
Cc: Latchesar Ionkov <lucho@ionkov.net>,
 Martin Brandenburg <martin@omnibond.com>,
 Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 samba-technical@lists.samba.org, linux-xfs@vger.kernel.org,
 Mike Marshall <hubcap@omnibond.com>, linux-cifs@vger.kernel.org,
 Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
 linux-afs@lists.infradead.org, cluster-devel@redhat.com,
 Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, devel@lists.orangefs.org,
 Shyam Prasad N <sprasad@microsoft.com>,
 Eric Van Hensbergen <ericvh@gmail.com>, Tom Talpey <tom@talpey.com>,
 linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 Xiubo Li <xiubli@redhat.com>,
 Trond Myklebust <trond.myklebust@hammerspace.com>, linux-nfs@vger.kernel.org,
 Paulo Alcantara <pc@cjr.nz>, Jeff Layton <jlayton@kernel.org>,
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
X-Proofpoint-GUID: p654msihQnCntNFapfIjTTZDcTKA8GVw
X-Proofpoint-ORIG-GUID: p654msihQnCntNFapfIjTTZDcTKA8GVw
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAFNkxjf1mf3dlBVq1iqm9K5xtTms3Cj4rR77sTTFitD9Cp5p6aARYf2AEuJ0TkW
 XjkquU/kwyUYsPPoayHMqKCxUzMArBHE4tmj+qvIk3Uomi+b5+XtaOdCPl1XzTuj
 FbwwaLV/oFhKBFJaVb6KpoYKj7uf2S3j7CWXD0Vuhs2jct2O49/jfFZOnZDlhxM6
 47/PSisnIuotET9dVpJ7GP4D292YNWeEtom/vuZhEzoRg/nhLQm0oibR8UgNevIW
 jYMGbLAe2J5T68h+2pt6uc6ASnXBP7WQokGfOkoj7hBM8nKwvoJVQnsx1Ihr37Wg
 l6IStD57ejA1+17VEeLpZvH4XY3Wb3Znqz76f+bhrlatOKegmiC5PBtkaOkh9sVR
 6L2JtLRCmZgmVkIBDoqaVCWD4t2rW1fNl6fp0OCP2WM/aMhhgIB2NXg6cvZ5jDMc
 0sVV7GNirFmRyFOr6Jx2+40qDfQlNl4ZMbhVj3W+nzBWsfQV7GpW0LppfN1yNSg/
 5fRMKRBNv5HNQHig/aH49Texea57bAxNzo5E255lesvA

On Tue, Nov 22, 2022 at 03:51:31AM +0000, Matthew Wilcox wrote:
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

#include <linux/wait.h>

struct file;
struct fasync_struct;



_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
