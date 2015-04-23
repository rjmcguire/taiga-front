ProjectsListingDirective = (projectsService) ->
    link = (scope, el, attrs, ctrl) ->
        scope.vm = {}
        itemEl = null
        tdom = el.find(".js-sortable")

        tdom.sortable({
            dropOnEmpty: true
            revert: 200
            axis: "y"
        })

        tdom.on "sortstop", (event, ui) ->
            itemEl = ui.item
            project = itemEl.scope().project
            index = itemEl.index()
            sorted_project_ids = _.map(scope.vm.projects.all, (p) -> p.id)
            sorted_project_ids = _.without(sorted_project_ids, project.id)
            sorted_project_ids.splice(index, 0, project.id)
            sortData = []
            for value, index in sorted_project_ids
                sortData.push({"project_id": value, "order":index})

            projectsService.bulkUpdateProjectsOrder(sortData)

        scope.vm.projects = projectsService.projects

    directive = {
        templateUrl: "projects/listing/listing.html"
        scope: {}
        link: link
    }

    return directive

angular.module("taigaProjects").directive("tgProjectsListing",
    ["tgProjects", ProjectsListingDirective])