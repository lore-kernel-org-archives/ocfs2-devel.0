From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 02 Mar 2009 08:50:36 +0800
Subject: [Ocfs2-devel] Patch to move ocfs2_slot_info to slot_map.h
In-Reply-To: <1235786454-17019-1-git-send-email-srinivas.eeda@oracle.com>
References: <1235786454-17019-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <49AB2D5C.7070809@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Srini,
	could you please use git-format-patch -n next time to generate the 
patch set? It would make the patches have title like [1/3], [2/3]... So 
that it is easy for readers to read from the beginning. Thanks.

Regards,
Tao

Srinivas Eeda wrote:
> Next 3 patches does the following
> 1) movies ocfs2_slot_info struct from slot_map.c to slot_map.h
> 2) patch to recover orphans during mount even if the journal is clean
> 3) patch to recovery orphans in offline slots
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
