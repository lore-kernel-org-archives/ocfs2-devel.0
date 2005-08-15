From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon Aug 15 17:29:46 2005
Subject: [Ocfs2-devel] ocfs2-1.0.1 ebuilds
In-Reply-To: <20050815221450.GA29912@ca-server1.us.oracle.com>
References: <42F800E5.2080706@yu.net> <43010710.2060800@yu.net>
	<20050815221450.GA29912@ca-server1.us.oracle.com>
Message-ID: <4301175A.6050101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have not seen the changes in code but the comments in the bug
indicate they have to do with adding umounts in o2cb stop.

Maybe a better idea would be to have a generic ocfs2 mount/umount
service as follows:
http://oss.oracle.com/bugzilla/attachment.cgi?id=162

This one is for SLES9. Maybe someone can write one up for gentoo.

If so, please add it as an attachment to bug:
http://oss.oracle.com/bugzilla/show_bug.cgi?id=524

Doc-ing this would be far easier.

Thanks
Sunil

Manish Singh wrote:

>On Mon, Aug 15, 2005 at 11:20:16PM +0200, lazar obradovic wrote:
>  
>
>>Gentoo ocfs2 1.0.1 ebuilds are available from 
>>http://bugs.gentoo.org/show_bug.cgi?id=98024
>>    
>>
>
>A few comments and questions:
>
>  
>
>>KEYWORDS="-* ~x86"
>>    
>>
>
>Does that mean this is only enabled for x86 platforms? 1.0.x works on
>x86_64 and ia64 too.
>
>The glib2 dependency in the tools should not be in the gtk2 option,
>since ocfs2cdsl and debug.ocfs2 depend on it too, and they are command
>line tools. Passing --disable-gtktest in the non-gtk2 case is kind of
>silly, since there isn't any test for gtk itself, only pygtk.
>
>The python binding for VTE is needed for some ocfs2console functionality
>(though it does work without it).
>
>Why are you using --prefix=/ ?
>
>It looks like you are still installing a sample cluster.conf. This makes
>no sense, there's no sane defaults for it, and putting the sample will
>only lead to confusion.
>
>Replacing the o2cb init script with your own is a bad idea. This makes
>the gentoo distribution gratuitiously incompatible with the OCFS2
>documentation out there, as well as breaking some ocfs2console
>functionality. Please don't do this.
>
>-Manish
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>  
>
