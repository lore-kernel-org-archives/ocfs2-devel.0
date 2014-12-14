From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Sun, 14 Dec 2014 01:24:14 -0600
Subject: [Ocfs2-devel] ocfs2-tools repository and documentation
In-Reply-To: <54874E4C.8040006@citrix.com>
References: <54874E4C.8040006@citrix.com>
Message-ID: <548D3B1E.5030309@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Germano,

On 12/09/2014 01:32 PM, Germano Percossi wrote:
> Hi,
>
> Sorry if this has been asked in the past but I did not
> find anything in the archive.
>
> It is not very clear to me where are the most up-to-date
> ocfs-tools repository (both source code and
> packages) and documentation.
>
> For development I am looking at
> https://oss.oracle.com/git/?p=ocfs2-tools.git;a=summary but the most
> recent commit seems to be more than
> 1 year old.

Yes, if you don't count the last 2 patches, it is more close to 3 years 
now ;)

Since the patches were not being updated. I started maintaining an 
alternate repository where I am putting all the bugs reported at SUSE:

https://github.com/goldwynr/ocfs2-tools

Branch suse-fixes has the fixes found by SUSE over the "upstream" branch.

Branch nocontrold has the patches for the feature of doing away with 
ocfs2_controld to work with the latest corosync/pacemaker stack. Patches 
for the kernel are already in the kernel but the ones in the tools need 
some review.

I had a mail conversation with Srini and he has promised to update the 
upstream branch soon.

Regards,

-- 
Goldwyn



>
> I found an RPM (asking a colleague of mine to ask one of his contacts
> in Oracle) here
> http://public-yum.oracle.com/repo/OracleLinux/OL7/0/base/x86_64/getPackageSource/ocfs2-tools-1.8.0-16.el7.src.rpm.
> When I inspected the content I found, comparing it to another package we
> have, the following:
> - a spec file (ok)
> - some patches (ok)
> - a tar.gz (ok but..)
>
> The tar.gz is ocfs2-tools-1.8.0.tar.gz. The first strange thing is
> that there are no versions tagged 1.8.0 in the git repo I am watching.
> The other thing is, in our old RPM we have a tar.gz with the same name.
> When I compared the content I found they differ just for the
> vendor/rhel7 directory. Its content though is not in the git repository.
>
> Is this repository the right one?
>
> Similar doubts apply to documentation (referring to 1.6 version of the
> tools and subversion as repository) and RPM repositories.
>
> Would you please point me to the right development resources?
>
> Thanks you,
> Germano
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
