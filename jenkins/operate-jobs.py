#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import os
import sys
import jenkins


#reload(sys)
#sys.setdefaultencoding("utf-8")

# get job cofigure save as xml file
def get_jobs_config(jenkins_server, save_to_dir = os.getcwd(), job_name = ""):
    server = jenkins_server
    dir_name = save_to_dir

    if os.path.isdir(dir_name):
        pass
    else:
        print(dir_name, "directory is no exist, create it!")
        try:
            os.mkdir(dir_name)
        except Exception as e:
            print(e)
            return

    # get one job's config
    if job_name == "":
        pass
    else:
        if server.job_exists(job_name):
            file_name = os.path.join(dir_name, job_name + ".xml")
            f = open(file_name, "w")
            job_config = server.get_job_config(job_name)
            f.write(job_config)
            f.close()
        else:
            print(job_name, "job is no exist")
        return

    jobs_total_counts = server.jobs_count()
    failed_jobs_counts = 0
    failed_jobs = []

    # get all jobs' config
    all_jobs= server.get_all_jobs()
    for item in all_jobs:
        job_name = item['name']
        try:
            if(server.job_exists(job_name)):
                file_name = os.path.join(dir_name, job_name + ".xml")
                f = open(file_name, "w")
                job_config = server.get_job_config(job_name)
                f.write(job_config)
                f.close()
        except:
            raise
            failed_jobs_counts += 1
            failed_jobs.append(job_name)
            pass

    print("there is ", jobs_total_counts - failed_jobs_counts, "/", jobs_total_counts, "jobs' config file got success!")

    return 


def create_job_from_file(jenkins_server, xml_file_name):
    server = jenkins_server
    file_name = xml_file_name
    job_name = os.path.basename(xml_file_name)
    job_name = os.path.splitext(job_name)[0]

    if os.access(file_name, os.R_OK):
        try:
            f = open(file_name, "r")
            content = f.read()
            if(server.job_exists(job_name)):
                print(job_name, "job already exist!")
            else:
                server.create_job(job_name, content)
        except:
            raise
    else:
        print(file_name, "is no exist!")
    return 


# file extension filter
def end_with(*endstring):
    ends = endstring
    def run(s):
        f = map(s.endswith, ends)
        if True in f: 
            return s
    return run


def create_job_from_dir(jenkins_server, xml_dir = os.getcwd()):
    success_jobs = 0
    server = jenkins_server
    dir_name = xml_dir

    if os.path.isdir(dir_name):
        file_names = os.listdir(dir_name)
        a = end_with('.xml')
        file_names = filter(a, file_names)
    else:
        print(dir_name, "directory is no exist!")
        return 

    for item in file_names:
        file_name = os.path.join(dir_name, item) 
        if os.access(file_name, os.R_OK):
            job_name = item.replace('.xml', '') 
            try:
                f = open(file_name, "r")
                content = f.read()
                if(server.job_exists(job_name)):
                    print(job_name, "job is already exist, skip it!")
                    continue
                else:
                    server.create_job(job_name, content)
                    success_jobs += 1
            except:
                raise
        else:
            print(file_name, "is no exist!")

    print(success_jobs, "jobs have been created!")

    return 


def del_jobs(jenkins_server, job_name="all"):
    success_jobs_counts=0
    success_jobs=[]
    server = jenkins_server

    if job_name != "all":
        if(server.job_exists(job_name)):
            server.delete_job(job_name) 
            print(job_name, "job has been deleted!")
        else:
            print(job_name, "job is no exist!")
        return

    all_jobs = server.get_all_jobs()
    for item in all_jobs:
        job_name = item['name']
        try:
            if(server.job_exists(job_name)):
                server.delete_job(job_name) 
                success_jobs.append(job_name)
                success_jobs_counts += 1
            else:
                print(job_name, "job is no exist, skip it!")
                continue
        except:
            raise
        pass

    print(success_jobs_counts, "jobs have been deleted!")
    print("these are:", success_jobs)

    return 


def list_jobs(jenkins_server, opt=""):
    jobs_counts=0
    jobs_name=[]
    server = jenkins_server

    all_jobs = server.get_all_jobs()
    if opt == "-v":
        print(all_jobs)
        return
    for item in all_jobs:
        job_name = item['name']
        try:
            if(server.job_exists(job_name)):
                jobs_name.append(job_name)
            else:
                print(job_name, "job is no exist!")
                continue
        except:
            raise

    print("there are ", server.jobs_count(), " jobs in total!")
    print("these are:", jobs_name)

    return 


def copy_job(jenkins_server, old_job, new_job=""):
    if new_job == "":
        new_job = old_job + "_new"
    server = jenkins_server
    result = True

    if(server.job_exists(old_job)):
        if(server.job_exists(new_job)):
            print(new_job, "job is already exist!")
            print("create job ", new_job, " failed!")
            result = False 
        else:
            server.copy_job(old_job, new_job)
            print(new_job, " job based ", old_job, " has been created!")
    else:
        print(old_job, "job is no exist!")
        print("create job ", new_job, " failed!")
        result = False 

    return result


def usage(routine):
    print('Usage:')
    print('     ', routine, 'command para...')
    print('     ', 'command:', 'get_config | create | del | list | copy')


def main():
    args=len(sys.argv)
    if args >= 2:
        command = sys.argv[1]
    else:
        usage(sys.argv[0])
        sys.exit(1)

    #server = jenkins.Jenkins('http://10.10.1.101:8080', username="ivd", password="123456")
    server = jenkins.Jenkins('http://10.10.1.205:9091', username="admin", password="software")


    if command == "get_config":
        if args == 3:
            save_as_dir = sys.argv[2]
            get_jobs_config(server, save_as_dir)
            #get_jobs_config(server, "jobs-configs")
        elif args == 4:
            save_as_dir = sys.argv[2]
            job_name = sys.argv[3]
            get_jobs_config(server, save_as_dir, job_name)
        else:
            usage(sys.argv[0])
            print(sys.argv[0], " get_config <dir_name> [job_name]")
            sys.exit(0)
    elif command == "create":
        if args == 3:
            para = sys.argv[2]
        else:
            usage(sys.argv[0])
            sys.exit(1)

        if os.path.isfile(para):
            create_job_from_file(server, para)
        elif os.path.isdir(para):
            create_job_from_dir(server, para)
        else:
            print(para, "file or directory is exist!")
            print(sys.argv[0], " create <dir_name or xml_file_name without extension>")
            sys.exit(0)
    elif command == "del":
        if args == 3:
            job_name = sys.argv[2]
            if job_name == "all":
                # delete all jobs
                del_jobs(server)
            else:
                del_jobs(server, job_name)
        else:
            usage(sys.argv[0])
            print(sys.argv[0], " del <all or job_name> ")
    elif command == "list":
        if args == 3:
            opt = sys.argv[2]
            # list all jobs name and url, opt = "-v"
            list_jobs(server, opt)
        else:
            # only list all jobs name
            list_jobs(server)
    elif command == "copy":
        if args == 4:
            old_job = sys.argv[2]
            new_job = sys.argv[3]
            copy_job(server, old_job, new_job)
        elif args == 3:
            old_job = sys.argv[2]
            # use old job name + "_new" as new job name
            copy_job(server, old_job)
        else:
            usage(sys.argv[0])
            print(sys.argv[0], " copy <old_job_name> [new_job_name]")
            sys.exit(0)
    else:
        usage(sys.argv[0])
        sys.exit(0)


if __name__ == '__main__':
    main()
