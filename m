From: Smart Weblications GmbH - Florian Wiessner <f.wiessner@smart-weblications.de>
Date: Thu, 27 Nov 2014 17:50:23 +0100
Subject: [Ocfs2-devel] ocfs2_link:812 ERROR: status = -2 - Re: Linux 3.17.4
In-Reply-To: <20141121201253.GA8623@kroah.com>
References: <20141121201253.GA8623@kroah.com>
Message-ID: <5477564F.2070908@smart-weblications.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stable@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, lizf@kernel.org, joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, lizefan@huawei.com, pieter@boesman.nl, josh@joshtriplett.orgjlbec@evilplan.org

Am 21.11.2014 21:12, schrieb Greg KH:
> I'm announcing the release of the 3.17.4 kernel.
> 
> All users of the 3.17 kernel series must upgrade.
> 


When using ocfs2 on 3.17.4 (i have seen this since 3.14) and
mount-bind ocfs2 to a lxc-container, when postfix inside the lxc tries to
write mails to ocfs2 dir using virtual transport, kernel says:

[ 3812.352564] (virtual,25186,3):ocfs2_link:812 ERROR: status = -2

In 3.12 this did _NOT_ happen.

This code (from postfix virtual transport program 'virtual' seems to cause the
kernel message:

        newfile = concatenate(newdir, STR(buf), (char *) 0);
        if ((mail_copy_status = mail_copy(COPY_ATTR(state.msg_attr),
                                          dst, copy_flags, "\n",
                                          why)) == 0) {
            if (sane_link(tmpfile, newfile) < 0
                && (errno != ENOENT
                    || (make_dirs(curdir, 0700), make_dirs(newdir, 0700)) < 0
                    || sane_link(tmpfile, newfile) < 0)) {
                dsb_simple(why, mbox_dsn(errno, "4.2.0"),
                           "create maildir file %s: %m", newfile);
                mail_copy_status = MAIL_COPY_STAT_WRITE;
            }
        }
        if (unlink(tmpfile) < 0)
            msg_warn("remove %s: %m", tmpfile);
    }


/* sane_link - sanitize link() error returns */
int sane_link(const char *from, const char *to)
{
const char *myname = "sane_link";
int saved_errno;
struct stat from_st;
struct stat to_st;
/*
* Normal case: link() succeeds.
*/
if (link(from, to) >= 0)
return (0);
/*
* Woops. Save errno, and see if the error is an NFS artefact. If it is,
* pretend the error never happened.
*/
saved_errno = errno;
if (stat(from, &from_st) >= 0 && stat(to, &to_st) >= 0
&& from_st.st_dev == to_st.st_dev
&& from_st.st_ino == to_st.st_ino) {
msg_info("%s(%s,%s): worked around spurious NFS error",
myname, from, to);
return (0);
}
/*
* Nope, it didn't. Restore errno and report the error.
*/
errno = saved_errno;
return (-1);
}


This seems like a regression to me since this used to work in 3.12.33

After the error, the mail is in /tmp/ of the mailbox but not moved to the /new/
dir. Also, courier-imapd fails to move mails from inbox to subfolders with the
same error message, leaving the mails to move in /tmp/ so i suspect
sane_link(tempfile, newfile) to have a problem within the current ocfs2_link().

[ 3337.084292] (imapd,5766,5):ocfs2_link:812 ERROR: status = -2

Please help!


-- 

Mit freundlichen Gr??en,

Florian Wiessner

Smart Weblications GmbH
Martinsberger Str. 1
D-95119 Naila

fon.: +49 9282 9638 200
fax.: +49 9282 9638 205
24/7: +49 900 144 000 00 - 0,99 EUR/Min*
http://www.smart-weblications.de

--
Sitz der Gesellschaft: Naila
Gesch?ftsf?hrer: Florian Wiessner
HRB-Nr.: HRB 3840 Amtsgericht Hof
*aus dem dt. Festnetz, ggf. abweichende Preise aus dem Mobilfunknetz
