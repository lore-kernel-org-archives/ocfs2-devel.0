From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 10 Sep 2008 10:05:24 -0700
Subject: [Ocfs2-devel] Regarding OCFS2 Packages
In-Reply-To: <48C7F5A1.5060806@oracle.com>
References: <48C7F5A1.5060806@oracle.com>
Message-ID: <48C7FE54.70007@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2 1.2 and 1.4 are two different releases. If you want to
stay with 1.2., 1.2.9 would be the latest. With 1.4, 1.4.1 would be
the latest. We will continue to provide patch upgrades to both 1.2
and 1.4 in the short term. To learn more about 1.4, read the 1.4 user's
guide.

Sashi wrote:
> All,
>
> Following are my *customer OS/OCFS2 versions* are as follows:
>    
>     ofmoradr01:/apps/ofmdbf1/oracle:ofmf1> uname -a
>     Linux ofmoradr01 2.6.18-53.1.19.el5 #1 SMP Tue Apr 22 03:01:10 EDT 
> 2008 x86_64 x86_64 x86_64
>     GNU/Linux
>    
>     ofmoradr01:/apps/ofmdbf1/oracle:ofmf1> cat /etc/redhat-release
>     Red Hat Enterprise Linux Server release 5.1 (Tikanga)
>    
>     ofmoradr01:/apps/ofmdbf1/oracle:ofmf1> rpm -qa | grep ocfs2
>     ocfs2-tools-1.2.7-1.el5
>     ocfs2-2.6.18-53.1.19.el5-1.2.8-2.el5
>    
>     ofmoradr01:/apps/ofmdbf1/oracle:ofmf1> cat /proc/fs/ocfs2/version
>     OCFS2 1.2.8 Thu May  8 18:47:26 PDT 2008 (build 
> 9c7ae8bb50ef6d8791df2912775adcc5)
>
> *i, Metalink Note:391771.1 states that *
> The latest module package version is 1.2.9-1 for both Enterprise Linux 
> 4 and 5.
> The latest tools/console package version is 1.2.7-1 for both 
> Enterprise Linux 4 and 5.6.
>
> *ii, Official URL says that "on 2008.08.18  OCFS2 version 1.4.1-1 is 
> released "*
>
> http://oss.oracle.com/projects/ocfs2/news/
>
> So, now* my question is *what are the *latest version *of packages ( 
> kernel module and tools/console ) should i download and install to* 
> support my customer existing configurations ?
>
> *Any help is appreciated. Pl. respond to my mail_id.*
>
> *Thanks,
> Sashi.*
> *
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
