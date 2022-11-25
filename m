Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C2BBC6370B
	for <ocfs2-devel@archiver.kernel.org>; Sat, 26 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pda11jOTDAFHomSEYHTalg5kaszTvko3I5AjSF3nfkI=;
 b=ctm8N4Fkb2w2cH4rTtEtID3BCZ3MNaLxwKCMMXozfW3fy5dzBw+cHM/IBRd9bfYIZUnsjcGumr5w
   Do2DbBkV0Fw72KXl2C2c7JRxAHEJay0PtuCNuTG2FZ/CoyCx7t5X1IPzEZI8UzVccGGxWXSV3Bdj
   6KwrLznAMtw8IptX1bh+0uNFeUFPRfD7pY8Rp/nhuBa5V/8BaRdq+lxWEWY+5Qw77YwfqvPV/mWN
   lgzlirUMVQRk6evvvEQRjsQ/E3vnFdwVqXj7cGg6CgYsLJwmlUL920K1AnKRjQNS4qR6ReA12Ero
   v4diqXo3WxFMUMlg9/fLMtfgyp1LjuVTrPiFpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pda11jOTDAFHomSEYHTalg5kaszTvko3I5AjSF3nfkI=;
 b=r2RgM9j6tnH6kau1ARoF79v7QsMWyK7o7iKVpYOYnspT2BLwyBQnjM1nytFCKN7x7wJNppY/iVC9
   VAJyq60JgEGi733YzhspmO4Ja5dGPG96kDB3N3eDhfiaa/XKiyvECnU3uEIrzDAeeCJUDCffd78D
   Ohpyzoa54gRNhrPKfo3lV1MRdVXm+JAI1STVk3Y61yC1CNCtM4duKDMbAq59VkC/yJT1fCnFLrXb
   2+nYEgRT+fes3DADYEdVAE4z2SYB2+gZKq83N9En8snpu+Ro2y/t2psjlaZlg3kwzqfyru+PcnZ8
   Z4mz/UAaPX4HGuFnOb2HIL4CjwbJuD7T7nuJdA==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221104 64bit (built Nov  4
 2022))
 with ESMTPS id <0RLY0075BVZ16190@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 26 Nov 2022 18:13:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=I2TD8YnyUVRKaNNBGvfs3pUWZDwIFw5kNMaApqkurhc=; b=LNV2e8UbAEOQw/T25Fn0zcJFtt
 fNpKOR7AmYQmyKebyHLdQkC/VRgO+jC6IaDUeHAjw4EL0DsbkFM6Iqc2wV96JeHEovMJKBTXDZmhv
 ZBw2xsCMnqYGB42wL+ylBtaiFvmXn4+q48vjcw+DG90eOjgZU2/9rcOSLcqiIsrxuWaDw1SMMEzx7
 t7JkkxZCAEJ97Erz/o4KvknT6QpkedMLh6PAKj8gLWbA+2hlrTJV8E/LgdR9rDoShxcJCoTpm912V
 ABkJ97xsSUr6RQZKyn8cXzXou9+2BUXYywgtCMyz0UPAL3QT8v6w4dSbpiqIhsoN4SGRxmTtMbclh
 leUGm6UQ==;
Date: Fri, 25 Nov 2022 03:48:14 +0000
To: Jeff Layton <jlayton@kernel.org>
Message-id: <Y4A6/ozhUncxbimi@ZenIV>
References: <20221120210004.381842-1-jlayton@kernel.org>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20221120210004.381842-1-jlayton@kernel.org>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10541
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 phishscore=0 clxscore=-10 lowpriorityscore=0 malwarescore=0 mlxlogscore=728
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250028
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
X-Proofpoint-GUID: M4IhSeQJ1OaxRMUckCY27Q0ycCyFrILr
X-Proofpoint-ORIG-GUID: M4IhSeQJ1OaxRMUckCY27Q0ycCyFrILr
X-Mailman-Approved-At: Sat, 26 Nov 2022 18:13:43 +0000
Reporting-Meta:
 AAF8K8Q7KWTIDIicEyKapnY9M5qe6l2np/VIU0GUtewJuzO0tLhdcog4rgNIQeJX
 +emZOK60LzW3oNw3catBHhyHXT/Pvq2OrW7VvLE6vOOCy5s7eogT6C3ougGyKtzR
 egEyfGOsaXd7L9MWKQqUtXOqlS2L4ebv23hVdEcmvIRU2DXYnVTLGFzG1J/90u/Q
 b9hm2nEG8Mc+XwJAfoN8Eu8QhtltJ+9TztbBrrIusU1U1kk9iMdmQ4ibJamXYiy5
 NoDzoyXTqh1XQ4Q6sdEFNNmmn6lGj7ikap0n8Reto+vef0hDMfa6AaE5zr3Ezb6J
 FIh/jmD1cd02ul0O3JtNt24NUCAQI5hAERLP22KZrOxwmANSdEHzaexA/qdS6Ahk
 y+YrZACt70vn4joUXYEXU2WpxwVQGV+PAlWRVVuBG4NXVBoI7gP6wC4fuI4NDH+z
 Z1KxZ+YWL9Wr8rPq1kDBn5a5dM8/3ILG62MPhikWy62gYM2efAkW73gXXF5JDT/a
 Y9JsjjJIhQLqkkKgxzl08TQBHpopXmjTsWDXbNip6cmn

On Sun, Nov 20, 2022 at 03:59:57PM -0500, Jeff Layton wrote:

> --- /dev/null
> +++ b/include/linux/filelock.h
> @@ -0,0 +1,428 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_FILELOCK_H
> +#define _LINUX_FILELOCK_H
> +
> +#include <linux/list.h>
> +#include <linux/nfs_fs_i.h>

Umm... I'd add a comment along the lines of "struct file_lock has
a BS union by fs type; NFS side of things needs nfs_fs_i.h"

> +struct lock_manager_operations {
> +	void *lm_mod_owner;
> +	fl_owner_t (*lm_get_owner)(fl_owner_t);

Probably take fl_owner_t to some more neutral header...

> +#define locks_inode(f) file_inode(f)

Why do we still have that one, anyway?  Separate patch, obviously,
but I would take Occam's Razor to that entity...

> +struct files_struct;
> +extern void show_fd_locks(struct seq_file *f,
> +			 struct file *filp, struct files_struct *files);

If anything, that would be better off as fl_owner_t...  Again, a separate
patch.

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
