From: Eric Ren <zren@suse.com>
Date: Mon, 7 Nov 2016 18:23:25 +0800
Subject: [Ocfs2-devel] what is g_f_a_w_n() short for? thanks
Message-ID: <053e78ae-8c7e-33f7-1d69-68021e68206b@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Mark,

There is a piece of comment that confused me, please correct me:

https://github.com/torvalds/linux/blob/master/fs/ocfs2/file.c#L2274
```
ocfs2_file_write_iter() {
...
  /*
          * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
          * function pointer which is called when o_direct io completes so that
          * it can unlock our rw lock.
...
}
```
Should g_f_a_w_n() be g_f_a_w_i() instead? Because grep only hits 
(__)generic_file_write_iter() by pattern.

Thanks,
Eric

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20161107/60bb44c9/attachment.html 
