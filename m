Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 424EBC47088
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ElCFkdggTIWUrwPfkbSzORytlELv6VboQmFTr1ON+Yk=;
 b=HGUV5BdxSemOCFioWPnB3qKkR84ZVixBeGDx5OpnZO+1X3BD7Rr2coOeWKx3JCS+C0SErlYARDGw
   ludqJC0fIyv3Myzv+vdfHLMKKUoR2bXsPGLdxA2oJEE6Tq3JP0tosYUBvh3KHRzL+eL5yRK/5Ksx
   H3Idf3wgLwvFGi3qA6ezQNmjT+i6vZCbZMAzzx+Erte2b+S3rLzi5aG0j+Vlfr6tneVTrhzBMfHt
   EJ73kNv1X/qWr1qVKqT5iUGTa6en9Nfoa6++HMOTMCf2g2S8OSGW7AQd3IMAEPiYuKb9PqLJhwTM
   Z64XWkSocEIRapA7q1KykTqR5FjHPPB6lTLAiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ElCFkdggTIWUrwPfkbSzORytlELv6VboQmFTr1ON+Yk=;
 b=adn8eAQdEBoi0m6yFi5EI/TAYh/awmSRk+N99XQJ/AnBEObixzwPBx1Hs5kZPOZ8zBfrftrA1fh5
   nw+UvIxsS3J+19J7QX+uX6c2JohjT6lWTGCEYV6+omfMwWwzBO2G6m4cZ+FAYHFSI/9O/RWwWxhP
   xsI3yNvukLAaRDJaxpgWp8P6vZKbUGX06/JgPGN7V0teHX8Stp32bl1R+X21raRtovMZ0OxTazF6
   SQPj5asyrCZbtklpTF5pBayt05ETURiqjauokTIL/RBW/S8B0JWL+O8LmaZn3zxRnsgw6VBJR/6B
   d469IkyKmjO1pYEH5pJ5ToK81xdbrt9fkSHwTQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY00FEFVYYMT60@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1669022413; bh=Rod4QLy3YHTf6Pn4dep500jsC9mccpeOXc9og6+BDkE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=AwhEY/dDW/xAQXKQY06ZdkenKH1tWXsfjYhpJkI7EXSR2DgDwEwDCSHzNF9BXj9SQ
 SRmwXBtkXFLo5i45Xf9DkLbPHTkzLhgSyU6Ewy+/E0iimScwd7sLrltK4hfnHmfW7d
 8oOYBFprjXXNqmeSRYCEp55DvWIHg95tusp6OMpmYNe5vkGsQYiv1ais/6fskFZuzK
 uUbHhjNrsueFnhzd2mOqwd0qe/UoMHjckc6z+qtLRQY3ZNPeN5L9zkefeakhpbiPjO
 9DJMO1GukybzD83AVos0vGE7HL0vhvIWV/ZtQqIyXq/7BH3gAP7oHnpceMszm/pILM
 yD+FZeeIzoiPw==
Date: Mon, 21 Nov 2022 10:19:59 +0100
To: Jeff Layton <jlayton@kernel.org>
Message-id: <20221121091959.nzcunop3byncxa77@wittgenstein>
References: <20221120210004.381842-1-jlayton@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221120210004.381842-1-jlayton@kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10537
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
From: Christian Brauner via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christian Brauner <brauner@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-GUID: ydm_HuMAhr7E7KHMWrwvri50ga0XMSAw
X-Proofpoint-ORIG-GUID: ydm_HuMAhr7E7KHMWrwvri50ga0XMSAw
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAEmrC2/UhTqKnLmm/sYlqSb+ARjmOWiGpOLyoFrD9XjLFWZ0a+vIi2a3YlRJAce
 2B0Fh4N+fgHqIbVArOAHVXgwkV9zWPuE0huNG2KqrrFhEFsTJ6dg4BB9fdvlaF0C
 +tuKQ4jNzt9sBBcUg2Gtwc7N84WoIrkOb+HKC7X/ciANKFhiUA6L6cpPoCfUuzAp
 jF4USLr4ajlp1yBoZJZ0E8LYh6hk9NF6lzkUPRkzTWt9tqJS78BfRp2m4tkGLfND
 UUOqrAV5FwoTOIE37iiQRIdRsfpMbpCy38D7Ce5/xF3Q9AK6TlgZRsptf6VzrCam
 kxFs/HlDAA1yh/E+Xz2L8ikaDkcqXQNfxVm4MXnuzwZUqoggtHWthkxRnooa5He0
 jxxfvls6byz062KcFrHe552gYvz4nyw83E5Jev5GiS8M1EDXH5d8nzTpqClxI3e9
 ef2bikns2giMNhMYggOo+UQlCHSwUTMYCIWqFMsEI7cU53lWSXMCovhn62tRHbFu
 vZ9MiEIcXjBQDgBk80LYVnSMm+QWVAearpdJ6aBlBhhU

On Sun, Nov 20, 2022 at 03:59:57PM -0500, Jeff Layton wrote:
> The file locking definitions have lived in fs.h since the dawn of time,
> but they are only used by a small subset of the source files that
> include it.
> 
> Move the file locking definitions to a new header file, and add the
> appropriate #include directives to the source files that need them. By
> doing this we trim down fs.h a bit and limit the amount of rebuilding
> that has to be done when we make changes to the file locking APIs.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---

Looks good to me,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
