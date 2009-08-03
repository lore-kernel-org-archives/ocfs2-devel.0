From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon,  3 Aug 2009 11:13:28 -0700
Subject: [Ocfs2-devel] Non sparse init fix v3
Message-ID: <1249323209-28169-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

One line fix from Joel's version. Also, some comments removed.

18:58 <sunil>         wc->w_first_new_cpos =
18:58 <sunil> -               ocfs2_align_bytes_to_clusters(inode->i_sb, i_size_read(inode));
18:58 <sunil> +               ocfs2_clusters_for_bytes(inode->i_sb, i_size_read(inode));
