From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Thu Mar 25 12:09:55 2004
Subject: [Ocfs2-devel] 1st time file system initialization code
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B0EFC6D@orsmsx410.jf.intel.com>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0EFC6D@orsmsx410.jf.intel.com>
Message-ID: <40632066.6060105@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I thought i saw markf add the code to tune.c. If that code is complete,
we should be able to call it from mkfs.

Villalovos, John L wrote:

>I'm starting to look into trying to get mkfs.ocfs2 to support a complete
>file system initialization.
>
>So I figure I need to take all the 1st time initialization code and move
>it to mfks.
>
>So I was just hoping for some pointers to what I will probably need to
>move.  Any help is appreciated :)
>
>John
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>  
>
